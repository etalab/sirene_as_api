class API::V3::EtablissementsController < ApplicationController
  include Scopable::Controller
  include Pagy::Backend

  def index
    @pagy, @results = pagy(scoped_results)

    render json: message_empty, status: 404 and return if @results.empty?
    render json: @results, status: 200, meta: pagination_pagy
  end

  # add siret to scopes and send it to #index
  def show
    request.query_parameters[:siret] = etablissements_params[:siret]
    index
  end

  private

  def scoped_results
    apply_scopes(Etablissement).all
  end

  def etablissements_params
    params.permit(:siret)
  end
end
