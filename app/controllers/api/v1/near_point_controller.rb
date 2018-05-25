require 'sunspot'

class API::V1::NearPointController < ApplicationController
  def show
    latitude = latlong_params[:lat] || latlong_params[:latitude]
    longitude = latlong_params[:long] || latlong_params[:longitude] # test this
    radius = latlong_params[:radius] || 5

    render_bad_request && return unless latitude && longitude

    search = search_nearby_etablissements(latitude, longitude, radius)

    render_payload(search)
  end

  def render_bad_request
    render json: { message: 'bad request: missing latitude or longitude' }, status: 400
  end

  def search_nearby_etablissements(latitude, longitude, radius)
    Etablissement.search do
      with(:location).in_radius(latitude, longitude, radius, bbox: true)
    end
  end

  def render_payload(search)
    results = search.results

    if !results.blank?
      render_payload_success(search, results)
    else
      render_payload_not_found
    end
  end

  def render_payload_success(search, results)
    results_payload = {
      total_results: search.total,
      total_pages: results.total_pages,
      etablissements: results
    }
    render json: results_payload, status: 200
  end

  def render_payload_not_found
    render json: { message: 'no results found' }, status: 404
  end

  private

  def latlong_params
    params.permit(:latitude, :longitude, :lat, :long, :radius)
  end
end
