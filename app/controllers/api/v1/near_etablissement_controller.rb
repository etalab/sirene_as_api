require 'sunspot'

# Note that we return near etablissements by APET (etablissement) not by APEN (entreprise)
class API::V1::NearEtablissementController < ApplicationController
  def show
    etablissement = search_from_siret || return
    options = options_from_params

    search =  search_around_etablissement(etablissement, options)
    results = search.results
    # Deleting searched etablissement from results
    results.delete(etablissement)

    render_payload(search, results)
  end

  private

  def search_from_siret
    siret = near_etablissement_params[:siret]

    etablissement = EtablissementV2.find_by(siret: siret)
    render json: { message: 'invalid SIRET' }, status: 400 if etablissement.nil?
    etablissement
  end

  def options_from_params
    {
      only_same_activity: near_etablissement_params[:only_same_activity] || false,
      approximate_activity: near_etablissement_params[:approximate_activity] || false,
      radius: near_etablissement_params[:radius] || 5,
      page: page_param_as_integer,
      per_page: per_page_default_10_max_100
    }
  end

  def page_param_as_integer
    near_etablissement_params[:page].nil? ? 1 : near_etablissement_params[:page].to_i
  end

  def per_page_default_10_max_100
    per_page = near_etablissement_params[:per_page] || 10
    per_page.to_i < 100 ? per_page : 100
  end

  def search_around_etablissement(etablissement, options)
    EtablissementV2.search do |s|
      # Less precise but faster search with bbox
      s.with(:location).in_radius(etablissement[:latitude], etablissement[:longitude], options[:radius], bbox: true)

      s.paginate page: options[:page], per_page: options[:per_page]

      with_faceting(s, options, etablissement)
    end
  end

  def with_faceting(search, options, etablissement)
    search.facet :activite_principale
    search.with(:activite_principale, etablissement[:activite_principale]) if options[:only_same_activity]
    search.adjust_solr_params { |p| add_similar_activities(p, etablissement) } if options[:approximate_activity]
  end

  def add_similar_activities(solr_params, etablissement)
    solr_params[:fq].push("activite_principale_s: #{approximated_activity(etablissement)}")
  end

  def approximated_activity(etablissement)
    # 6204Z will become 62*
    etablissement[:activite_principale].slice(0, 2) + '*'
  end

  def render_payload(search, results)
    if !results.blank?
      render_payload_success(search, results)
    else
      render json: { message: 'no results found' }, status: 404
    end
  end

  def render_payload_success(search, results)
    results_payload = {
      total_results: search.total - 1,
      total_pages: results.total_pages,
      per_page: results.per_page,
      page: page_param_as_integer,
      etablissements: results
    }
    render json: results_payload, status: 200
  end

  def near_etablissement_params
    params.permit(:siret, :radius, :only_same_activity, :approximate_activity, :page, :per_page)
  end
end
