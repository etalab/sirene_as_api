require 'rails_helper'

example_json = {
  responseHeader: {
    status: 0,
    QTime: 154
  },
  suggest: {
    suggest: {
      EXAMPLE: {
        numFound: 0,
        suggestions: ['my_suggestion']
      }
    }
  }
}

describe API::V1::SuggestController do
  context 'when doing a simple search', type: :request do
    it 'works' do
      keyword = 'test_suggestion'
      session = double('Net::HTTP')
      response = double('Net:HTTPSuccess')
      allow(response).to receive(:code).and_return('200')
      allow(response).to receive(:body).and_return(example_json.to_json)

      expect(Net::HTTP).to receive(:new).and_return(session)
      expect(session).to receive(:get)
        .with('/solr/test/suggesthandler?wt=json&suggest.q=test_suggestion')
        .and_return(response)

      get "/v1/suggest/#{keyword}" # This needs to be after expectations
    end
  end
end
