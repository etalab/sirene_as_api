class FullTextController < ApplicationController
  def show
    page = params[:page] || 1

    search = Etablissement.search do
      fulltext params[:id]
      facet :activite_principale
      with(:activite_principale, params[:activite_principale]) if params[:activite_principale].present?
      facet :code_postal
      with(:code_postal, params[:code_postal]) if params[:code_postal].present?

      without(:nature_mise_a_jour).any_of(%w[O E]) # Scoping
      paginate page: page, per_page: 10
    end

    results = search.results

    if results.blank?
      render json: { message: 'no results found' }, status: 404
    else
      results_payload = {
        total_results: search.total,
        total_pages: results.total_pages,
        per_page: results.per_page,
        page: page,
        etablissement: results
      }

      render json: results_payload, status: 200
    end
  end

  def full_text_params
    params.permit(:id, :page)
  end
end
