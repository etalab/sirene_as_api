class API::V2::SirenChildrenController < ApplicationController
  def show
    @results = EtablissementV2.where(siren: children_params[:siren]).pluck(*essential_infos)

    @result_siege = []
    @results_children = []
    rebuild_hash_results

    if !@result_siege.blank?
      render_payload_siren_children(@result_siege.first, @results_children)
    else
      render json: { message: 'no results found' }, status: 404
    end
  end

  private

  def rebuild_hash_results
    @results.each do |result|
      if result[0] == '0'
        @results_children << Hash[essential_infos.zip result]
      else
        @result_siege << Hash[essential_infos.zip result]
      end
    end
  end

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
      is_siege
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
