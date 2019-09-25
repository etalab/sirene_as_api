class ApplicationController < ActionController::API
  def pagination_pagy
    {
      total_results: @pagy.count,
      per_page: @pagy.items,
      total_pages: @pagy.pages,
      page: @pagy.page
    }
  end

  def message_empty
    { message: 'no results found' }
  end

  def pagination_solr(collection); end
end
