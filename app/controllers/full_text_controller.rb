require 'sunspot'


# TODO: Implement @filter_nature_prospection
# TODO: Spellchecking have been moved to solr so no need to do a recursive spellcheck,
# only one extra search is okay.
# TODO: Factorize & clean
class FullTextController < ApplicationController
  @filter_nature_prospection = true

  def show
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @number_of_searches = 1
    spellcheck_search(params[:text], page, per_page)
  end

  def spellcheck_search(query, page, per_page)
    search = search_with_solr_options(query, page, per_page)
    results = search.results

    if !results.blank?

       # to delete
      puts 'FOUND. SPELLCHECK COLLATION:' + search.spellcheck_collation.to_s
      puts 'SUGGESTIONS SUNSPOT:' + search.spellcheck_suggestions.to_s

      results_payload = {
        total_results: search.total,
        total_pages: results.total_pages,
        per_page: results.per_page,
        page: page,
        etablissement: results
      }
      render json: results_payload, status: 200
    else
      spellchecked_query = search.spellcheck_collation
      # binding.pry
       # to delete
      puts 'NOT FOUND. SPELLCHECK:' + search.spellcheck_collation.to_s
      puts 'SUGGESTIONS SUNSPOT:' + search.spellcheck_suggestions.to_s

      if spellchecked_query.nil? || @number_of_searches >= 2
        render json: { message: 'no results found' }, status: 404
      else
        @number_of_searches += 1
        spellcheck_search(spellchecked_query, page, per_page)
      end
    end
  end

  def search_with_solr_options(keyword, page, per_page)
    search = Etablissement.search do
      fulltext keyword do
        # Better scoring for phrases, with words separated up until 1 word.
        # Search "Commune Montpellier" will be boosted for result "Commune de Montpellier"
        phrase_fields :nom_raison_sociale => 2.0
        phrase_slop 1

        # Boost results for Mairies, as it often searched.
        # Search "Montpellier" will be boosted for the actual city Etablissement.
        boost(2) { with(:enseigne).equal_to("MAIRIE") }
      end

      # Faceting / Filtering
      facet :activite_principale
      with(:activite_principale, params[:activite_principale]) if params[:activite_principale].present?
      facet :code_postal
      with(:code_postal, params[:code_postal]) if params[:code_postal].present?
      facet :is_ess
      with(:is_ess, params[:is_ess]) if params[:is_ess].present?
      with_filter_entrepreneur_individuel if params[:is_entrepreneur_individuel].present?
      # facet :enseigne
      # with(:enseigne, "MAIRIE")
      # Scoping
      without(:nature_mise_a_jour).any_of(%w[O E])
      without(:statut_prospection, 'N')

      # Spellcheck / pagination
      spellcheck :count => 2
      paginate page: page, per_page: per_page

      # Ordering
      order_by(:score, :desc)
      order_by(:tranche_effectif_salarie_entreprise, :desc)
    end
    search
  end
end

def with_filter_entrepreneur_individuel
  if params[:is_entrepreneur_individuel] == 'yes'
    with(:nature_entrepreneur_individuel, ('1'..'9').to_a)
  elsif params[:is_entrepreneur_individuel] == 'no'
    without(:nature_entrepreneur_individuel, ('1'..'9').to_a)
  end
end

# Code below used to debug Solr Spellchecking.
module Sunspot::Search
  class StandardSearch
    def spellcheck_collation(*terms)
      # Uncomment the following line for console feedback
      # puts 'SPELLCHECK FROM INSIDE SUNSPOT: ' + solr_spellcheck.to_s

      # Following line changed since Sunspot doesn't allow collation on 1 term on this version.
      # Length is usually > 2 on most sunspot versions, we put it at > 0 here.
      # TODO: Check why we don't have last version of the code here.
      if solr_spellcheck['suggestions'] && solr_spellcheck['suggestions'].length > 0
        collation = terms.join(" ").dup if terms

        # If we are given a query string, tokenize it and strictly replace
        # the terms that aren't present in the index
        if terms.length > 0
          terms.each do |term|
            if (spellcheck_suggestions[term]||{})['origFreq'] == 0
              collation[term] = spellcheck_suggestion_for(term)
            end
          end
        end

        # If no query was given, or all terms are present in the index,
        # return Solr's suggested collation.
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
