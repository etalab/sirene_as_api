require 'rails_helper'

describe API::V1::FullTextController do
  context 'when doing a search that isnt found', type: :request do
    it 'doesnt return anything' do
      get '/v1/full_text/ghost_company_5678754579828655384'
      expect(response.body).to look_like_json
      expect(body_as_json).to match(
        message: 'no results found',
        spellcheck: nil,
        suggestions: []
      )
      expect(response).to have_http_status(404)
    end
  end

  # Fulltext works on nom_raison_sociale too
  context 'when fulltext searching a Commune name', type: :request do
    let!(:etablissement1) do
      create(:etablissement_v2, id: 1, nom_raison_sociale: 'foobar company')
    end

    let!(:etablissement2) do
      create(:etablissement_v2, id: 2, nom_raison_sociale: 'another etablissement')
    end

    let!(:etablissement3) do
      create(:etablissement_v2, id: 3, nom_raison_sociale: 'etablissement to find')
    end

    it 'finds correctly the Etablissement at the Commune searched' do
      EtablissementV2.reindex

      get '/v1/full_text/etablissement%20to%20find'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_etablissements[:etablissement].size).to equal(1)
      expect(result_etablissements[:etablissement].first[:id]).to equal(3)
    end
  end

  # Fulltext works on commune names too
  context 'when fulltext searching a Commune name', type: :request do
    let!(:etablissement1) do
      create(:etablissement_v2, id: 1, nom_raison_sociale: 'foobar company', libelle_commune: 'PARIS')
    end

    let!(:etablissement2) do
      create(:etablissement_v2, id: 2, nom_raison_sociale: 'another etablissement', libelle_commune: 'MARSEILLE')
    end
    let!(:etablissement3) do
      create(:etablissement_v2, id: 3, nom_raison_sociale: 'etablissement to find', libelle_commune: 'MONTPELLIER')
    end

    it 'finds correctly the Etablissement at the Commune searched' do
      EtablissementV2.reindex

      get '/v1/full_text/montpellier'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_etablissements[:etablissement].size).to equal(1)
      expect(result_etablissements[:etablissement].first[:id]).to equal(3)
    end
  end

  # Fulltext works on adress (l4_normalisee)
  context 'when fulltext searching an adress', type: :request do
    let!(:etablissement1) do
      create(:etablissement_v2, id: 1, nom_raison_sociale: 'foobar company', l4_normalisee: '12 avenue Ali Baba')
    end
    let!(:etablissement2) do
      create(:etablissement_v2, id: 2, nom_raison_sociale: 'another etablissement', l4_normalisee: "42 rue de l'auto-stoppeur")
    end

    let!(:etablissement3) do
      create(:etablissement_v2, id: 3, nom_raison_sociale: 'etablissement to find', l4_normalisee: '12 rue de la grenouille')
    end

    it 'finds correctly the Etablissement at the adress searched' do
      EtablissementV2.reindex

      get '/v1/full_text/12%20rue%20grenouille'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_etablissements[:etablissement].first[:id]).to equal(3)
    end
  end

  # Fulltext works on libelle_activite_principale_entreprise
  context 'when fulltext searching an adress', type: :request do
    let!(:etablissement1) do
      create(:etablissement_v2, id: 1, nom_raison_sociale: 'foobar company', libelle_activite_principale_entreprise: 'Programmation')
    end

    let!(:etablissement2) do
      create(:etablissement_v2, id: 2, nom_raison_sociale: 'another etablissement', libelle_activite_principale_entreprise: 'Location de pédalos')
    end

    let!(:etablissement3) do
      create(:etablissement_v2, id: 3, nom_raison_sociale: 'etablissement to find', libelle_activite_principale_entreprise: 'Activités du spectacle')
    end

    it 'finds correctly the Etablissement at the adress searched' do
      EtablissementV2.reindex

      get '/v1/full_text/spectacle'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_etablissements[:etablissement].size).to equal(1)
      expect(result_etablissements[:etablissement].first[:id]).to equal(3)
    end
  end

  # Fulltext works on enseigne
  context 'when fulltext searching an enseigne', type: :request do
    let!(:etablissement1) do
      create(:etablissement_v2, id: 1, nom_raison_sociale: 'foobar company', enseigne: 'Lol Market')
    end

    let!(:etablissement2) do
      create(:etablissement_v2, id: 2, nom_raison_sociale: 'another etablissement', enseigne: 'The Prancing Poney Inn')
    end

    let!(:etablissement3) do
      create(:etablissement_v2, id: 3, nom_raison_sociale: 'etablissement to find', enseigne: 'Secretariat General')
    end

    it 'finds correctly the Etablissement' do
      EtablissementV2.reindex

      get '/v1/full_text/secretariat%20general'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_etablissements[:etablissement].size).to equal(1)
      expect(result_etablissements[:etablissement].first[:id]).to equal(3)
    end
  end

  # Fulltext works on sigle
  context 'when fulltext searching sigle', type: :request do
    let!(:etablissement1) { create(:etablissement_v2, id: 1, sigle: 'FOOBAR') }
    let!(:etablissement2) { create(:etablissement_v2, id: 2, sigle: nil) }
    let!(:etablissement3) { create(:etablissement_v2, id: 3, sigle: 'DONOTFIND') }
    it 'finds correctly the Etablissement' do
      EtablissementV2.reindex

      get '/v1/full_text/foobar'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_etablissements[:etablissement].size).to equal(1)
      expect(result_etablissements[:etablissement].first[:id]).to equal(1)
    end
  end

  # Fulltext works on nom commercial (l2_normalisee)
  context 'when fulltext searching an enseigne', type: :request do
    let!(:etablissement1) do
      create(:etablissement_v2, id: 1, nom_raison_sociale: 'foobar company', l2_normalisee: 'Lol Market')
    end

    let!(:etablissement2) do
      create(:etablissement_v2, id: 2, nom_raison_sociale: 'another etablissement', l2_normalisee: 'The Prancing Poney Inn')
    end

    let!(:etablissement3) do
      create(:etablissement_v2, id: 3, nom_raison_sociale: 'etablissement to find', l2_normalisee: 'Secretariat General')
    end

    it 'finds correctly the Etablissement' do
      EtablissementV2.reindex

      get '/v1/full_text/secretariat%20general'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_etablissements[:etablissement].size).to equal(1)
      expect(result_etablissements[:etablissement].first[:id]).to equal(3)
    end
  end

  # Fulltext works on a combination of Etablissement name and commune
  context 'when fulltext searching an Etablissement name & a Commune name', type: :request do
    let!(:etablissement1) do
      create(:etablissement_v2, id: 1, nom_raison_sociale: 'foobar company', libelle_commune: 'PARIS')
    end

    let!(:etablissement2) do
      create(:etablissement_v2, id: 2, nom_raison_sociale: 'ThisEtablissement to not find', libelle_commune: 'MARSEILLE')
    end

    let!(:etablissement3) do
      create(:etablissement_v2, id: 3, nom_raison_sociale: 'ThisEtablissement to find', libelle_commune: 'MONTPELLIER')
    end

    it 'finds correctly the Etablissement at the commune searched' do
      EtablissementV2.reindex

      get '/v1/full_text/montpellier%20thisetablissement'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_etablissements[:etablissement].size).to eq(1)
      expect(result_etablissements[:etablissement].first[:id]).to equal(3)
    end
  end

  # Prioritize Etablissements which are Mairies
  context 'when looking for an Etablissement which have a Mairie (commune)', type: :request do
    let!(:etablissement1) do
      create(:etablissement_v2, id: 1, nom_raison_sociale: 'Commune de Montpellier', enseigne: 'MAIRIE')
    end

    let!(:etablissement2) do
      create(:etablissement_v2, id: 2, nom_raison_sociale: 'Commune de Montpellier', enseigne: 'null')
    end

    let!(:etablissement3) do
      create(:etablissement_v2, id: 3, nom_raison_sociale: 'Montpellier', enseigne: 'others')
    end

    let!(:etablissement4) do
      create(:etablissement_v2, id: 4, nom_raison_sociale: 'Unrelated', enseigne: 'null')
    end

    it 'prioritize the Mairie Etablissement result' do
      EtablissementV2.reindex

      get '/v1/full_text/montpellier'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_etablissements[:etablissement].size).to equal(3)
      expect(result_etablissements[:etablissement].first[:id]).to equal(1)
    end
  end

  # Per page param
  context 'when specifying the per_page param', type: :request do
    it 'return the right number of results per page' do
      per_page_custom = 15
      per_page_custom.times do
        create(:etablissement_v2, nom_raison_sociale: 'FOOBARCOMPANY')
      end
      EtablissementV2.reindex

      get "/v1/full_text/foobarcompany?per_page=#{per_page_custom}"

      expect(response.body).to look_like_json
      result_hash = body_as_json
      etablissements = result_hash.extract!(:etablissement, :suggestions)
      expect(result_hash).to match(
        total_results: per_page_custom,
        total_pages: 1,
        per_page: per_page_custom,
        page: 1,
        spellcheck: nil
      )
      expect(etablissements[:etablissement].size).to eq(15)
    end
  end

  # Limitation of per page param
  context 'when asking for a per_page over 100', type: :request do
    it 'returns results with 100 per_page' do
      per_page_asked = 120
      number_etablissements = 10
      number_etablissements.times do
        create(:etablissement_v2, nom_raison_sociale: 'foobarcompany')
      end
      EtablissementV2.reindex

      get "/v1/full_text/foobarcompany?per_page=#{per_page_asked}"

      expect(response.body).to look_like_json
      result_hash = body_as_json
      result_hash.extract!(:etablissement, :suggestions)
      expect(result_hash).to match(
        total_results: number_etablissements,
        total_pages: 1,
        per_page: 100,
        page: 1,
        spellcheck: nil
      )
    end
  end

  # Faceting
  context 'when doing a simple search with no facet', type: :request do
    let!(:etablissement) { create(:etablissement_v2, nom_raison_sociale: 'foobarcompany') }
    it 'return the correct results' do
      EtablissementV2.reindex

      get '/v1/full_text/foobarcompany'

      expect(response.body).to look_like_json
      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement, :suggestions)
      expect(result_hash).to match(
        total_results: 1,
        total_pages: 1,
        per_page: 10,
        page: 1,
        spellcheck: nil
      )
      name_result = result_etablissements[:etablissement][0][:nom_raison_sociale]
      expect(name_result).to match('foobarcompany')
      expect(response).to have_http_status(200)
    end
  end

  context 'when doing a 1 facet search', type: :request do
    let!(:etablissement) { create(:etablissement_v2, nom_raison_sociale: 'foobarcompany', activite_principale: 'APE41') }
    let!(:etablissement2) { create(:etablissement_v2, nom_raison_sociale: 'foobarcompany', activite_principale: 'APE42') }
    it 'return the correct results' do
      EtablissementV2.reindex

      get '/v1/full_text/foobarcompany?activite_principale=APE42'

      expect(response.body).to look_like_json
      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement, :suggestions)
      expect(result_hash).to match(
        total_results: 1,
        total_pages: 1,
        per_page: 10,
        page: 1,
        spellcheck: nil
      )
      name_result = result_etablissements[:etablissement][0][:nom_raison_sociale]
      expect(name_result).to match('foobarcompany')
      expect(response).to have_http_status(200)
    end
  end

  context 'when doing a 2 facet search', type: :request do
    let!(:etablissement) { create(:etablissement_v2, nom_raison_sociale: 'foobarcompany', activite_principale: 'ACTIVITY1', code_postal: '92000') }
    let!(:etablissement2) { create(:etablissement_v2, nom_raison_sociale: 'foobarcompany', activite_principale: 'ACTIVITY2', code_postal: '75000') }
    let!(:etablissement3) { create(:etablissement_v2, nom_raison_sociale: 'foobarcompany', activite_principale: 'ACTIVITY2', code_postal: '34070') }
    it 'return the correct results' do
      EtablissementV2.reindex

      get '/v1/full_text/foobarcompany?activite_principale=ACTIVITY2&code_postal=34070'

      expect(response.body).to look_like_json
      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement, :suggestions)
      expect(result_hash).to match(
        total_results: 1,
        total_pages: 1,
        per_page: 10,
        page: 1,
        spellcheck: nil
      )
      name_result = result_etablissements[:etablissement][0][:nom_raison_sociale]
      expect(name_result).to match('foobarcompany')
      expect(response).to have_http_status(200)
    end
  end

  # Spellchecking
  context 'when a word contains a typo', type: :request do
    let!(:etablissement1) { create(:etablissement_v2, nom_raison_sociale: 'foobarcompany') }
    let!(:etablissement2) { create(:etablissement_v2, nom_raison_sociale: 'samplecompany') }
    let!(:etablissement3) { create(:etablissement_v2, nom_raison_sociale: 'anothercompany') }
    it 'spellcheck correctly and return the correct word' do
      EtablissementV2.reindex

      get '/v1/full_text/fo0barcompany' # Typo on purpose

      expect(response.body).to look_like_json
      result_hash = body_as_json
      result_spellcheck = result_hash[:spellcheck]
      expect(result_spellcheck).to match('foobarcompany')
      expect(response).to have_http_status(404)
    end
  end

  # Spellchecking collation
  context 'when two close words both contains a typo', type: :request do
    let!(:etablissement) { create(:etablissement_v2, nom_raison_sociale: 'foobar company') }
    let!(:etablissement2) { create(:etablissement_v2, nom_raison_sociale: 'sample company') }
    let!(:etablissement3) { create(:etablissement_v2, nom_raison_sociale: 'another company') }
    it 'spellcheck correctly and return the correct word' do
      EtablissementV2.reindex

      get '/v1/full_text/fo0bar%20compani' # Typos on purpose

      expect(response.body).to look_like_json
      result_hash = body_as_json
      result_spellcheck = result_hash[:spellcheck]
      expect(result_spellcheck).to match('foobar company')
      expect(response).to have_http_status(404)
    end
  end

  # Suggestions : FST implementation works only from prefix, so we find etablissement3
  context 'when a name can be suggested', type: :request do
    include_context 'mute interactors'

    let!(:etablissement1) { create(:etablissement_v2, id: 1, nom_raison_sociale: 'FOOBAR COMPANY') }
    let!(:etablissement2) { create(:etablissement_v2, id: 2, nom_raison_sociale: 'ANOTHER ETABLISSEMENT') }
    let!(:etablissement3) { create(:etablissement_v2, id: 3, nom_raison_sociale: 'ETABLISSEMENT TO FIND') }
    it 'suggests it' do
      EtablissementV2.reindex
      SolrRequests.new.build_dictionary

      get '/v1/full_text/etablissement'

      result_hash = body_as_json
      result_hash.extract!(:etablissement, :spellcheck)
      expect(result_hash).to match(
        total_results: 2,
        total_pages: 1,
        per_page: 10,
        page: 1,
        suggestions: ['etablissement to find']
      )
    end
  end

  # Params filter is_entrepreneur_individuel
  context 'when doing a search for entrepreneur individuel', type: :request do
    let!(:etablissement) { create(:etablissement_v2, nom_raison_sociale: 'foobarcompany', nature_entrepreneur_individuel: '1') }
    let!(:etablissement2) { create(:etablissement_v2, nom_raison_sociale: 'foobarcompany', nature_entrepreneur_individuel: '6') }
    let!(:etablissement3) { create(:etablissement_v2, nom_raison_sociale: 'foobarcompany', nature_entrepreneur_individuel: '9') }
    let!(:etablissement4) { create(:etablissement_v2, nom_raison_sociale: 'foobarcompany') }
    it 'show the entrepreneurs individuels in results when I want them' do
      EtablissementV2.reindex

      get '/v1/full_text/foobarcompany?is_entrepreneur_individuel=yes'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(3)
    end
    it 'doesnt show the entrepreneurs individuels when I dont want them' do
      EtablissementV2.reindex

      get '/v1/full_text/foobarcompany?is_entrepreneur_individuel=no'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(1)
    end
  end

  # Params filter departement
  context 'when doing a search filtering by department', type: :request do
    let!(:etablissement) { create(:etablissement_v2, id: 1, nom_raison_sociale: 'foobarcompany', departement: '75') }
    let!(:etablissement2) { create(:etablissement_v2, id: 2, nom_raison_sociale: 'foobarcompany', departement: '06') }
    let!(:etablissement3) { create(:etablissement_v2, id: 3, nom_raison_sociale: 'foobarcompany', departement: '34') }
    let!(:etablissement4) { create(:etablissement_v2, id: 4, nom_raison_sociale: 'foobarcompany') }
    it 'works' do
      EtablissementV2.reindex

      get '/v1/full_text/foobarcompany?departement=34'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(1)
      expect(result_etablissements[:etablissement].first[:id]).to eq(3)
    end
  end

  # Params filter code_commune
  context 'when doing a search filtering by code_commune', type: :request do
    let!(:etablissement) { create(:etablissement_v2, id: 1, nom_raison_sociale: 'foobarcompany', commune: '175', departement: '11') }
    let!(:etablissement2) { create(:etablissement_v2, id: 2, nom_raison_sociale: 'foobarcompany', commune: '186', departement: '11') }
    let!(:etablissement3) { create(:etablissement_v2, id: 3, nom_raison_sociale: 'foobarcompany', commune: '34', departement: '08') }
    let!(:etablissement4) { create(:etablissement_v2, id: 4, nom_raison_sociale: 'foobarcompany') }
    it 'works' do
      EtablissementV2.reindex

      get '/v1/full_text/foobarcompany?code_commune=11186'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(1)
      expect(result_etablissements[:etablissement].first[:id]).to eq(2)
    end
  end

  # Params filter tranche_effectif_salarie_entreprise
  context 'when doing a search filtering by tranche_effectif_salarie_entreprise', type: :request do
    let!(:etablissement) { create(:etablissement_v2, id: 1, nom_raison_sociale: 'foobarcompany', tranche_effectif_salarie_entreprise: '00') }
    let!(:etablissement2) { create(:etablissement_v2, id: 2, nom_raison_sociale: 'foobarcompany', tranche_effectif_salarie_entreprise: 'NN') }
    let!(:etablissement3) { create(:etablissement_v2, id: 3, nom_raison_sociale: 'foobarcompany', tranche_effectif_salarie_entreprise: '03') }
    let!(:etablissement4) { create(:etablissement_v2, id: 4, nom_raison_sociale: 'foobarcompany') }
    it 'works' do
      EtablissementV2.reindex

      get '/v1/full_text/foobarcompany?tranche_effectif_salarie_entreprise=03'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(1)
      expect(result_etablissements[:etablissement].first[:id]).to eq(3)
    end
  end

  # Order results by score then Etablissement size
  context 'when doing a search for entrepreneur individuel', type: :request do
    let!(:etablissement1) { create(:etablissement_v2, id: 1, nom_raison_sociale: 'foobarcompany', tranche_effectif_salarie_entreprise: '0') }
    let!(:etablissement2) { create(:etablissement_v2, id: 2, nom_raison_sociale: 'foobarcompany', tranche_effectif_salarie_entreprise: '11') }
    let!(:etablissement3) { create(:etablissement_v2, id: 3, nom_raison_sociale: 'foobarcompany2', tranche_effectif_salarie_entreprise: '0') }
    let!(:etablissement4) { create(:etablissement_v2, id: 4, nom_raison_sociale: 'foobarcompany2', tranche_effectif_salarie_entreprise: '11') }
    let!(:etablissement5) { create(:etablissement_v2, id: 5, nom_raison_sociale: 'randomcompany', tranche_effectif_salarie_entreprise: '53') }
    it 'order close matchs by score then by tranche_effectif_salarie_entreprise' do
      EtablissementV2.reindex

      get '/v1/full_text/foobar*'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      id_from_etablissements = result_etablissements[:etablissement].map { |x| x[:id] }
      expect(id_from_etablissements).to eq([2, 4, 1, 3])
    end
  end

  # Solr synonyms work
  context 'when searching with a common contraction', type: :request do
    let!(:etablissement1) { create(:etablissement_v2, id: 1, nom_raison_sociale: 'madame rene') }
    it 'finds the correct result corresponding to the contraction extended' do
      EtablissementV2.reindex

      get '/v1/full_text/mme%20rene'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(1)
    end
  end

  context 'when searching without a common contraction', type: :request do
    let!(:etablissement1) { create(:etablissement_v2, id: 1, nom_raison_sociale: 'mme rene') }
    it 'finds the correct exact result' do
      EtablissementV2.reindex

      get '/v1/full_text/mme%20rene'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(1)
    end
  end

  context 'when searching with a common contraction', type: :request do
    let!(:etablissement1) { create(:etablissement_v2, id: 1, nom_raison_sociale: 'mme rene') }
    it 'finds the correct result corresponding exactly' do
      EtablissementV2.reindex

      get '/v1/full_text/madame%20rene'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(1)
    end
  end

  # Solr pluralization and singularization (SnowballPorterFilterFactory)
  context 'when searching a name singular', type: :request do
    let!(:etablissement1) { create(:etablissement_v2, id: 1, nom_raison_sociale: 'Cave de Montpellier') }
    it 'finds the correct plural result' do
      EtablissementV2.reindex

      get '/v1/full_text/Caves%20de%20Montpellier'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(1)
    end
  end

  context 'when searching a name plural', type: :request do
    let!(:etablissement1) { create(:etablissement_v2, id: 1, nom_raison_sociale: 'Caves de Montpellier') }
    it 'finds the correct singular result' do
      EtablissementV2.reindex

      get '/v1/full_text/Cave%20de%20Montpellier'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(1)
    end
  end

  # Solr apostrophe management
  context 'when a name contains an apostrophe', type: :request do
    let!(:etablissement1) { create(:etablissement_v2, id: 1, nom_raison_sociale: 'lady') }
    let!(:etablissement2) { create(:etablissement_v2, id: 2, nom_raison_sociale: "M\'lady") }
    let!(:etablissement3) { create(:etablissement_v2, id: 3, nom_raison_sociale: 'Mlady') }
    it 'correctly see apostrophe as a separator' do
      EtablissementV2.reindex

      get '/v1/full_text/lady'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(2)
    end
  end
end
