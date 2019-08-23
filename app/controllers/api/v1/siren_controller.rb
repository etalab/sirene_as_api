class API::V1::SirenController < ApplicationController
  def show
    result_siege = EtablissementV2.where(siren: siren_params[:siren], is_siege: '1')
    results_sirets = EtablissementV2.select('siret').where(siren: siren_params[:siren], is_siege: '0').pluck(:siret)

    if !result_siege.blank?
      render_payload_siren(result_siege, results_sirets)
    else
      render json: { message: 'no results found' }, status: 404
    end
  end

  private

  def render_payload_siren(result_siege, results_sirets)
    results_payload = {
      total_results: results_sirets.size + 1,
      siege_social: result_siege.first,
      other_etablissements_sirets: results_sirets,
      numero_tva_intra: numero_tva_for(siren_params[:siren])
    }
    render json: results_payload, status: 200
  end

  def numero_tva_for(siren)
    tva_key =  (12 + 3 * (siren.to_i % 97)) % 97
    tva_number = tva_key.to_s + siren.to_s
    'FR' + tva_number
  end

  def siren_params
    params.permit(:siren)
  end
end
