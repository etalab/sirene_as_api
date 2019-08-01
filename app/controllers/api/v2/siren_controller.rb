class API::V2::SirenController < ApplicationController
  include PayloadSerializer

  def show
    result_siege = EtablissementV2.where(siren: siren_params[:siren], is_siege: '1')
    result_sirets = EtablissementV2.select('siret').where(siren: siren_params[:siren], is_siege: '0').pluck(:siret)

    payload = SirenPayload.new(siren_params[:siren], result_siege, result_sirets)

    render json: payload.body, status: payload.status
  end

  private

  def siren_params
    params.permit(:siren)
  end
end
