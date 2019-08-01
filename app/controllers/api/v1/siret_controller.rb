class API::V1::SiretController < ApplicationController
  def show
    r = EtablissementV2.find_by(siret: siret_params[:siret])

    if r.nil?
      render json: { message: 'no results found' }, status: 404
    else
      render json: { etablissement: r }, status: 200
    end
  end

  private

  def siret_params
    params.permit(:siret)
  end
end
