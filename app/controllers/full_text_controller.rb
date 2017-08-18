class FullTextController < ApplicationController
  def show
    @page = params[:page] || 1
    @this_is_not_our_first_search = false

    spellcheck_search(params[:id])
  end

  def spellcheck_search(keyword)
    search = search_with_solr_options(keyword)
    results = search.results

    unless results.blank?
      results_payload = {
        total_results: search.total,
        total_pages: results.total_pages,
        per_page: results.per_page,
        page: @page,
        etablissement: results
      }
      render json: results_payload, status: 200
    else
      if search.spellcheck_suggestion_for(keyword).blank? ||  @this_is_not_our_first_search
        render json: { message: 'no results found' }, status: 404
      else
        @this_is_not_our_first_search = true
        spellchecked_keyword = search.spellcheck_suggestion_for(keyword)
        spellcheck_search(spellchecked_keyword)
      end
    end
  end

  def search_with_solr_options(keyword)
    search = Etablissement.search do
      fulltext keyword
      facet :activite_principale
      with(:activite_principale, params[:activite_principale]) if params[:activite_principale].present?
      facet :code_postal
      with(:code_postal, params[:code_postal]) if params[:code_postal].present?

      spellcheck :count => 3

      without(:nature_mise_a_jour).any_of(%w[O E]) # Scoping
      paginate page: @page, per_page: 10
    end
    search
  end

  def full_text_params
    params.permit(:id, :page)
  end
end
