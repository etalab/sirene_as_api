class API::V1::NumeroRNAController < ApplicationController
  def show
    r = EtablissementV2.find_by(numero_rna: rna_params[:rna])

    if r.nil?
      render json: { message: 'no results found' }, status: 404
    else
      render json: { etablissement: r }, status: 200
    end
  end

  private

  def rna_params
    params.permit(:rna)
  end
end
