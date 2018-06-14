class API::V1::SiretController < ApplicationController
  def show
    r = Etablissement.find_by(siret: siret_params[:siret])

    if r.nil? # || %w[O E].include?(r.nature_mise_a_jour) # Uncomment to filter results out of commercial diffusion
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
