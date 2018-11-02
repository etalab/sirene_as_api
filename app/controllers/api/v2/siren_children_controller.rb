class API::V2::SirenChildrenController < ApplicationController
  def show
    result_siege = Etablissement.where(siren: children_params[:siren], is_siege: '1').select(*essential_infos).first
    results_children = Etablissement.where(siren: children_params[:siren], is_siege: '0').select(*essential_infos)

    if !result_siege.blank?
      render_payload_siren_children(result_siege, results_children)
    else
      render json: { message: 'no results found' }, status: 404
    end
  end

  private

  def render_payload_siren_children(result_siege, results_children)
    results_payload = {
      total_results: results_children.size + 1,
      siege_social: result_siege,
      other_etablissements: results_children
    }
    render json: results_payload, status: 200
  end

  def essential_infos
    %i[
      siren
      siret
      enseigne
      geo_adresse
      longitude
      latitude
    ]
  end

  def children_params
    params.permit(:siren)
  end
end
