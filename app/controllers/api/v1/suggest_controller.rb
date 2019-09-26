class API::V1::SuggestController < ApplicationController
  include Suggestions

  def show
    keyword = suggest_params[:suggest_query]
    return if keyword.empty?

    response = SolrRequests.new(keyword).request_suggestions
    render json: [], status: response.code && return unless response.is_a? Net::HTTPSuccess
    suggestions = extract_suggestions(response.body)
    render json: { suggestions: suggestions }, status: 200
  end

  private

  def suggest_params
    params.permit(:suggest_query)
  end
end
