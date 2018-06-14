require 'sunspot'

class API::V1::FullTextController < ApplicationController
  FILTER_NATURE_PROSPECTION = true

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
      render_payload_success(query, search, results, page)
    else
      render_payload_not_found(query, search)
    end
  end

  def search_with_solr_options(keyword, page, per_page)
    search = Etablissement.search do
      run_search_with_main_options(keyword)
      # Faceting / Filtering
      with_faceting_options
      # Scoping
      without_statut_prospection if FILTER_NATURE_PROSPECTION
      # Filter for entrepreneur individuel if asked
      with_filter_entrepreneur_individuel if fulltext_params[:is_entrepreneur_individuel].present?
      with_filter_code_commune if fulltext_params[:code_commune].present?
      # Spellcheck / pagination
      spellcheck count: 2
      paginate page: page, per_page: per_page
      # Suggestions
      # autocomplete suggestions, using: :nom_raison_sociale
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
      nom_raison_sociale: 3.0,
      libelle_commune: 2.0,
      libelle_activite_principale_entreprise: 1.0,
      l4_normalisee: 1.0,
      l2_normalisee: 1.0,
      enseigne: 1.0
    )

    # Better scoring for phrases, with words separated up until 1 word.
    # Search "Commune Montpellier" will be boosted for result "Commune de Montpellier"
    phrase_fields nom_raison_sociale: 2.0
    phrase_slop 1

    # Better scoring if someone search "rue mairie" for "rue de la mairie"
    phrase_fields l4_normalisee: 2.0
    phrase_slop 2

    # Boost results for Mairies, as it often searched.
    # Search "Montpellier" will be boosted for the actual city Etablissement.
    boost(5) { with(:enseigne).equal_to('MAIRIE') }
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

def without_statut_prospection
  without(:nature_mise_a_jour).any_of(%w[O E])
  without(:statut_prospection, 'N')
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

def render_payload_success(query, search, results, page)
  results_payload = {
    total_results: search.total,
    total_pages: results.total_pages,
    per_page: results.per_page,
    page: page,
    etablissement: results,
    spellcheck: search.spellcheck_collation,
    suggestions: request_suggestions(query)
  }
  render json: results_payload, status: 200
end

def render_payload_not_found(query, search)
  results_payload = {
    message: 'no results found',
    spellcheck: search.spellcheck_collation,
    suggestions: request_suggestions(query)
  }
  render json: results_payload, status: 404
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
