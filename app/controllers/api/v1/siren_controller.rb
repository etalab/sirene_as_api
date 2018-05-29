class API::V1::SirenController < ApplicationController
  def show
    @results = Etablissement.where(siren: params[:siren])
    @results_sirets = @results.pluck(:siret)

    if !@results.blank?
      render_payload_siren
    else
      render json: { message: 'no results found' }, status: 404
    end
  end

  def render_payload_siren
    results_payload = {
      total_results: @results_sirets.size,
      siege_social: siege_etablissement,
      # siege_name: the_siege_name(results, siege_siret), TODO: implement later
      other_etablissements_sirets: not_siege_sirets,
      # other_etablissements_names: not_siege_names(results), TODO: implement later
      numero_tva_intra: numero_tva_for(params[:siren])
    }
    render json: results_payload, status: 200
  end

  def siege_siret
    siege_etablissement[:siret]
  end

  def siege_etablissement
    @results.where(is_siege: '1').first
  end

  def not_siege_sirets
    @results_sirets.reject { |siret| siege_siret.include?(siret) }
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
