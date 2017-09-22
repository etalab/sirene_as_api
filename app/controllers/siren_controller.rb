class SirenController < ApplicationController
  def show
    results = Etablissement.where(siren: params[:siren])

    if !results.blank?
      results_payload = {
        total_results: results.size,
        etablissements: results
      }
      render json: results_payload, status: 200
    else
      render json: { message: 'no results found' }, status: 404
    end
  end

  def siren_params
    params.permit(:siren)
  end
end
