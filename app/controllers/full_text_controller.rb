require 'sunspot'

class FullTextController < ApplicationController
  @filter_nature_prospection = true

  def show
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    @number_of_searches = 0
    spellcheck_search(params[:text], page, per_page)
  end

  def spellcheck_search(query, page, per_page)
    search = search_with_solr_options(query, page, per_page)
    results = search.results

    if !results.blank?
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
