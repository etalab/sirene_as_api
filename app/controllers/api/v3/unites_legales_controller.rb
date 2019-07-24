class API::V3::UnitesLegalesController < ApplicationController
  include Scopable::Controller
  include Pagy::Backend

  # TODO: Add param for custom mapping on Solr,
  # Add param for fullText value
  def index
    @pagy, @results = pagy(scoped_results)

    render json: message_empty, status: 404 and return if @results.empty?
    render json: @results, status: 200, meta: pagination_pagy
  end

  # add siret to scopes and send it to #index
  def show
    request.query_parameters[:siren] = unite_legale_params[:siren]
    index
  end

  private

  def scoped_results
    apply_scopes(UniteLegale).all
  end

  def unite_legale_params
    params.permit(:siren)
  end
end
