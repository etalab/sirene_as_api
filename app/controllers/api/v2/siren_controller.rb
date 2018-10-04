class API::V2::SirenController < ApplicationController
  def show
    result_siege = Etablissement.where(siren: siren_params[:siren], is_siege: '1')
    results_sirets = Etablissement.select('siret').where(siren: siren_params[:siren], is_siege: '0').pluck(:siret)
    results_rnm = RnmAPICall.new(siren_params[:siren]).call

    if !result_siege.blank?
      render_payload_siren(result_siege, results_sirets, JSON.parse(results_rnm)) # TODO protect result ?
    else
      render json: { message: 'no results found' }, status: 404
    end
  end

  private

  def render_payload_siren(result_siege, results_sirets, results_rnm)
    results_payload = {
      sirene: {
        data: {
          total_results: results_sirets.size + 1,
          siege_social: result_siege.first,
          other_etablissements_sirets: results_sirets
        },
        status: '200',
        metadata: {
          id: 'SIRENE',
          producteur: 'INSEE',
          date_derniere_maj: 'example-date'
        }
      },
      repertoire_national_metiers: {
        data: results_rnm,
        status: '200',
        metadata: {
          id: 'Répertoire National des Métiers',
          producteur: "Chambre de Métiers et de l'Artisanat",
          date_derniere_maj: 'example-date'
        }
      },
      computed: {
        data: {
          numero_tva_intra: numero_tva_for(siren_params[:siren])
        },
        metadata: {
          numero_tva_intra: {
            origin: "Computed by formula: 'FR' + '(12 + 3 * (siren % 97)) % 97' + 'siren'"
          }
        }
      }
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
