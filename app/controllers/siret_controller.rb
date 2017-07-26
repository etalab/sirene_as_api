class SiretController < ApplicationController
  def show
    r = Etablissement.find_by(siret: params[:id])

    # Don't show results out of commercial diffusion
    if r.nil? || %w[O E].include?(r.nature_mise_a_jour)
      render json: { message: 'no results found' }, status: 404
    else
      render json: { etablissement: r }, status: 200
    end
  end

  def siret_params
    params.permit(:id)
  end
end
