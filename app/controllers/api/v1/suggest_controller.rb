class API::V1::SuggestController < ApplicationController
  def show
    keyword = suggest_params[:suggest_query]
    return if keyword.empty?
    suggestions = SolrRequests.new(keyword).get_suggestions
    if suggestions.empty?
      render json: { message: 'no suggestions found' }, status: 404
    else
      render json: { suggestions: suggestions }, status: 200
    end
  end

  private

  def suggest_params
    params.permit(:suggest_query)
  end
end
