require 'sunspot'

class API::V1::NearbyEtablissementsController < ApplicationController
  def show
    r = Etablissement.find_by(siret: params[:siret])

    # TODO manage not found

    radius = params[:radius] || 5

    search = Etablissement.search do
      with(:location).in_radius(r[:latitude], r[:longitude], radius) # TODO use param radius and bbox
    end
    results = search.results
    results.delete(r)

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
      etablissements: results,
    }
  render json: results_payload, status: 200

  end

  def render_payload_not_found
    render json: { message: 'no results found' }, status: 404
  end
  def siret_params
    params.permit(:siret)
  end
end