class API::V2::SirenController < ApplicationController
  include PayloadFormatter

  def show
    result_siege = Etablissement.where(siren: siren_params[:siren], is_siege: '1')
    result_sirets = Etablissement.select('siret').where(siren: siren_params[:siren], is_siege: '0').pluck(:siret)
    result_rnm = RnmAPICall.new(siren_params[:siren]).call

    if ![result_siege, result_rnm].blank?
      render json: SirenPayload.new(siren_params[:siren], result_siege, result_sirets, result_rnm).payload, status: 200
    else
      render json: { message: 'no results found' }, status: 404
    end
  end

  private

  def siren_params
    params.permit(:siren)
  end
end
