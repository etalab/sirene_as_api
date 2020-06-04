class API::V3::EtablissementsController < ApplicationController
  include Scopable::Controller
  include Pagy::Backend

  def index
    @pagy, @results = pagy(scoped_results)

    render(json: message_empty, status: 404) && return if @results.empty?

    render json: @results, status: 200, meta: pagination_pagy
  end

  def show
    request.query_parameters[:siret] = etablissements_params[:siret]

    @results = scoped_results

    render(json: message_empty, status: 404) && return if @results.empty?

    render json: @results.first, status: 200
  end

  private

  def scoped_results
    apply_scopes(Etablissement).all
  end

  def etablissements_params
    params.permit(:siret)
  end
end
