require 'rails_helper'

describe API::V1::SuggestController do
  context 'when doing a simple search', type: :request do
    it 'creates a correct Solr request and return the result' do
      keyword = 'test_suggestion'
      request_instance = SolrRequests.new(keyword)

      expect(SolrRequests).to receive(:new).with(keyword).and_return(request_instance)
      expect(request_instance).to receive(:get_suggestions).and_return('example suggestion')
      get "/v1/suggest/#{keyword}" # This needs to be after expectations
    end

    it 'render the correct payload for no results' do
      keyword = 'test_suggestion_no_results_will_be_found'
      request_instance = SolrRequests.new(keyword)

      expect(SolrRequests).to receive(:new).with(keyword).and_return(request_instance)
      expect(request_instance).to receive(:get_suggestions).and_return('')
      get "/v1/suggest/#{keyword}"
      result_hash = body_as_json
      expect(result_hash).to match( message: 'no suggestions found' )
      expect(response).to have_http_status(404)
    end

    it 'render the correct payload for yes results' do
      keyword = 'test_suggestion_no_results_will_be_found'
      request_instance = SolrRequests.new(keyword)

      expect(SolrRequests).to receive(:new).with(keyword).and_return(request_instance)
      expect(request_instance).to receive(:get_suggestions).and_return('example suggestion')
      get "/v1/suggest/#{keyword}"
      result_hash = body_as_json
      expect(result_hash).to match( suggestions: 'example suggestion' )
      expect(response).to have_http_status(200)
    end
  end
end
