class SiretController < ApplicationController
  def show
    r = Etablissement.find_by(siret: params[:id])

    if r.nil?
      render json: { message: 'no results found' }, status: 404
    else
      render json: { etablissement: r }, status: 200
    end
  end

  def siret_params
    params.permit(:id)
  end
end
