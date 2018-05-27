require 'sunspot'

class API::V1::NearEtablissementController < ApplicationController
  def show
    etablissement = search_from_siret || return
    options = search_options_params

    search =  search_around_etablissement(etablissement, options)
    results = search.results
    # Deleting searched etablissement from results
    results.delete(etablissement)

    render_payload(search, results)
  end

  private

  def search_from_siret
    siret = near_etablissement_params[:siret]

    etablissement = Etablissement.find_by(siret: siret)
    render json: { message: 'invalid SIRET' }, status: 400 if etablissement.nil?
    etablissement
  end

  def search_options_params
    options = {
      only_same_activity: near_etablissement_params[:only_same_activity] || false,
      approximate_activity: near_etablissement_params[:approximate_activity] || false,
      radius: near_etablissement_params[:radius] || 5
    }
    options
  end

  def search_around_etablissement(etablissement, options)
    Etablissement.search do
      # Less precise but faster search with bbox
      with(:location).in_radius(etablissement[:latitude], etablissement[:longitude], options[:radius], bbox: true)

      facet :activite_principale
      with(:activite_principale, etablissement[:activite_principale]) if options[:only_same_activity]
      adjust_solr_params { |params| add_similar_activities(params, etablissement) } if options[:approximate_activity]
    end
  end

  def add_similar_activities(params, etablissement)
    params[:fq].push("activite_principale_s: #{approximated_activity(etablissement)}")
  end

  def approximated_activity(etablissement)
    # 6204Z will become 62*
    etablissement[:activite_principale].slice(0, 2) + '*'
  end

  def render_payload(search, results)
    if !results.blank?
      render_payload_success(search, results)
    else
      render_payload_not_found
    end
  end

  def render_payload_success(search, results)
    results_payload = {
      total_results: search.total - 1,
      total_pages: results.total_pages,
      etablissements: results
    }
    render json: results_payload, status: 200
  end

  def render_payload_not_found
    render json: { message: 'no results found' }, status: 404
  end

  def near_etablissement_params
    params.permit(:siret, :radius, :only_same_activity, :approximate_activity)
  end
end
