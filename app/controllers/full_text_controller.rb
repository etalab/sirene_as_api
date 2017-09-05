require 'sunspot'

class FullTextController < ApplicationController
  def show
    @page = params[:page] || 1
    @searches_done = 0
    spellcheck_search(params[:id])
  end

  def spellcheck_search(query)
    search = search_with_solr_options(query)
    results = search.results

    if !results.blank?
      results_payload = {
        total_results: search.total,
        total_pages: results.total_pages,
        per_page: results.per_page,
        page: @page,
        etablissement: results
      }
      render json: results_payload, status: 200
    else
      spellchecked_query = search.spellcheck_collation
      if spellchecked_query.nil? || @searches_done >= 3
        render json: { message: 'no results found' }, status: 404
      else
        @searches_done += 1
        spellcheck_search(spellchecked_query)
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

      spellcheck :count => 5

      without(:nature_mise_a_jour).any_of(%w[O E]) # Scoping
      paginate page: @page, per_page: 10
    end
    search
  end
end

# Modified Sunspot classes for making Spellcheck work.
module Sunspot::Search
  class StandardSearch
    def spellcheck_suggestion_for(term)
      if spellcheck_suggestions.nil? || spellcheck_suggestions[term].nil?
        return nil
      end
      spellcheck_suggestions[term]['suggestion'].sort_by do |suggestion|
        suggestion['freq']
      end.last['word']
    end

    def spellcheck_collation(*terms)
      if solr_spellcheck['suggestions'] && solr_spellcheck['suggestions'].length > 0
        collation = terms.join(" ").dup if terms

        if terms.length > 0
          terms.each do |term|
            if (spellcheck_suggestions[term]||{})['origFreq'] == 0
              collation[term] = spellcheck_suggestion_for(term)
            end
          end
        end

        if terms.length == 0
          collation = solr_spellcheck['collations'][-1]
        end

        collation
      else
        nil
      end
    end
  end
end
