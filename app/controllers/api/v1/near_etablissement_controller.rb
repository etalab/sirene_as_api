require 'sunspot'

class API::V1::NearEtablissementController < ApplicationController
  def show
    siret = near_etablissement_params[:siret]
    radius = near_etablissement_params[:radius] || 5
    options = {
      only_same_activity: near_etablissement_params[:only_same_activity] || false,
      approximate_same_activity: near_etablissement_params[:approximate_same_activity] || false
    }

    search_nearby_etablissements(siret, radius, options)
  end

  def search_nearby_etablissements(siret, radius, options)
    etablissement = search_from_siret(siret) || return

    search =  search_around_etablissement(etablissement, radius, options)
    results = search.results
    # Deleting searched etablissement from results
    results.delete(etablissement)

    render_payload(search, results)
  end

  def search_from_siret(siret)
    etablissement = Etablissement.find_by(siret: siret)
    render json: { message: 'invalid SIRET' }, status: 400 if etablissement.nil?
    etablissement
  end

  def search_around_etablissement(etablissement, radius, options)
    Etablissement.search do
      # Less precise but faster search with bbox
      with(:location).in_radius(etablissement[:latitude], etablissement[:longitude], radius, bbox: true)

      facet :activite_principale
      with(:activite_principale, etablissement[:activite_principale]) if options[:only_same_activity]
      if options[:approximate_same_activity]
        adjust_solr_params do |params|
          params[:fq].push("activite_principale_s: #{approximated_activity(etablissement)}")
        end
      end
    end
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

  private

  def near_etablissement_params
    params.permit(:siret, :radius, :only_same_activity, :approximate_same_activity)
  end
end
