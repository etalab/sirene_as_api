module Suggestions
  def extract_suggestions(solr_response_body)
    suggestions = []
    solr_response_hash = JSON.parse(solr_response_body)
    suggestions_parsed = solr_response_hash['suggest']['suggest'].to_a[0][1]['suggestions']
    suggestions_parsed.each do |hash|
      suggestions << hash['term']
    end
    suggestions
  end
end
