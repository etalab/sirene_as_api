class FullTextController < ApplicationController
  def show
    page = params[:page] || 1

    search = Etablissement.search do
      fulltext params[:id]
      paginate page: page, per_page: 10
    end

    results = search.results

    if results.nil?
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
