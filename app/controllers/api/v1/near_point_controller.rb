require 'sunspot'

class API::V1::NearPointController < ApplicationController
  def show
    render_bad_request && return unless latlong_params[:lat] && latlong_params[:long]

    search = search_nearby_etablissements

    render_payload(search)
  end

  private

  def render_bad_request
    render json: { message: 'bad request: missing latitude or longitude' }, status: 400
  end

  def search_nearby_etablissements
    radius = latlong_params[:radius] || 5

    EtablissementV2.search do |s|
      s.with(:location).in_radius(latlong_params[:lat], latlong_params[:long], radius, bbox: true)
      with_faceting(s)

      s.paginate page: page_param_as_integer, per_page: per_page_default_10_max_100
    end
  end

  def page_param_as_integer
    latlong_params[:page].nil? ? 1 : latlong_params[:page].to_i
  end

  def per_page_default_10_max_100
    per_page = latlong_params[:per_page] || 10
    per_page.to_i < 100 ? per_page : 100
  end

  def render_payload(search)
    results = search.results

    if !results.blank?
      render_payload_success(search, results)
    else
      render json: { message: 'no results found' }, status: 404
    end
  end

  def render_payload_success(search, results)
    results_payload = {
      total_results: search.total,
      total_pages: results.total_pages,
      per_page: results.per_page,
      page: page_param_as_integer,
      etablissements: results
    }
    render json: results_payload, status: 200
  end

  def with_faceting(search)
    search.facet :activite_principale
    search.with(:activite_principale, latlong_params[:activite_principale]) if latlong_params[:activite_principale]
    search.adjust_solr_params { |p| add_similar_activities(p) } if latlong_params[:approximate_activity]
  end

  def add_similar_activities(solr_params)
    solr_params[:fq].push("activite_principale_s: #{approximated_activity}")
  end

  def approximated_activity
    # 6204Z will become 62*
    latlong_params[:approximate_activity].slice(0, 2) + '*'
  end

  def latlong_params
    params.permit(:lat, :long, :radius, :page, :per_page, :approximate_activity, :activite_principale)
  end
end
