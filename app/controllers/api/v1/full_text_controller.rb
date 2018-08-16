require 'sunspot'

class API::V1::FullTextController < ApplicationController
  def show
    page = fulltext_params[:page] || 1
    per_page = per_page_default_10_max_100
    fulltext_search(fulltext_params[:text], page, per_page)
  end

  private

  def per_page_default_10_max_100
    per_page = fulltext_params[:per_page] || 10
    per_page.to_i < 100 ? per_page : 100
  end

  def fulltext_search(query, page, per_page)
    search = search_with_solr_options(query, page, per_page)
    results = search.results

    if !results.blank?
      render json: payload_success(query, search, results, page), status: 200
    else
      render json: payload_not_found(query, search), status: 404
    end
  end

  def search_with_solr_options(keyword, page, per_page)
    search = Etablissement.search do
      run_search_with_main_options(keyword)

      with_faceting_options
      with_filter_entrepreneur_individuel if fulltext_params[:is_entrepreneur_individuel].present?
      with_filter_code_commune if fulltext_params[:code_commune].present?
      # Spellcheck / pagination
      spellcheck count: 2
      paginate page: page, per_page: per_page
      # Ordering
      order_results_options
    end
    search
  end
end

def run_search_with_main_options(keyword)
  fulltext keyword do
    # Matches on name scores x3, on commune name scores x2
    fields(
      nom_raison_sociale: 1.8,
      libelle_commune: 1.0,
      libelle_activite_principale_entreprise: 1.0,
      l4_normalisee: 1.5,
      l2_normalisee: 1.0,
      enseigne: 1.7,
      sigle: 1.7
    )

    # This allows one word missing in phrase queries
    query_phrase_slop 1
    # Better scoring for phrases, with words separated up until 1 word.
    phrase_fields nom_raison_sociale: 1.5
    phrase_slop 1

    # Better scoring if someone search "rue mairie" for "rue de la mairie"
    phrase_fields l4_normalisee: 3.0
    phrase_slop 1

    # Boost results for Mairies, as they are main Etablissements of a city.
    boost(1.9) { with(:enseigne).equal_to('MAIRIE') }
  end
end

def with_faceting_options
  facet :activite_principale
  with(:activite_principale, fulltext_params[:activite_principale]) if fulltext_params[:activite_principale].present?
  facet :code_postal
  with(:code_postal, fulltext_params[:code_postal]) if fulltext_params[:code_postal].present?
  facet :is_ess
  with(:is_ess, fulltext_params[:is_ess]) if fulltext_params[:is_ess].present?
  facet :departement
  with(:departement, fulltext_params[:departement]) if fulltext_params[:departement].present?
end

def with_filter_entrepreneur_individuel
  if fulltext_params[:is_entrepreneur_individuel] == 'yes'
    with(:nature_entrepreneur_individuel, ('1'..'9').to_a)
  elsif fulltext_params[:is_entrepreneur_individuel] == 'no'
    without(:nature_entrepreneur_individuel, ('1'..'9').to_a)
  end
end

def with_filter_code_commune
  facet :departement
  with(:departement, fulltext_params[:code_commune].slice(0, 2))
  facet :commune
  with(:commune, fulltext_params[:code_commune].slice(2, 3))
end

def order_results_options
  order_by(:score, :desc)
  order_by(:tranche_effectif_salarie_entreprise, :desc)
end

def payload_success(query, search, results, page)
  {
    total_results: search.total,
    total_pages: results.total_pages,
    per_page: results.per_page,
    page: page,
    etablissement: results,
    spellcheck: search.spellcheck_collation,
    suggestions: request_suggestions(query)
  }
end

def payload_not_found(query, search)
  {
    message: 'no results found',
    spellcheck: search.spellcheck_collation,
    suggestions: request_suggestions(query)
  }
end

def request_suggestions(query)
  SolrRequests.new(query).get_suggestions
end

def fulltext_params
  params.permit(
    :text,
    :page,
    :per_page,
    :is_entrepreneur_individuel,
    :code_commune,
    :activite_principale,
    :code_postal,
    :is_ess,
    :departement
  )
end

# Code below used to debug Solr Spellchecking.
# rubocop:disable all
# :nocov:
module Sunspot::Search
  class StandardSearch
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
# :nocov:
# rubocop:enable all
