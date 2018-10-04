module PayloadFormatter
  class SirenPayload
    def initialize(siren, result_siege, results_sirets, results_rnm)
      @siren = siren
      @result_siege = result_siege.to_a.map(&:serializable_hash)[0]
      @result_siege_geo = @result_siege.extract!(
        'longitude',
        'latitude',
        'geo_score',
        'geo_type',
        'geo_adresse',
        'geo_id',
        'geo_ligne',
      )
      @results_sirets = results_sirets
      @results_rnm = results_rnm
    end

    # rubocop:disable Metrics/MethodLength
    def payload
      {
        sirene: {
          data: data_from_sirene,
          status: status_sirene,
          metadata: {
            id: 'SIRENE',
            producteur: 'INSEE',
            nature: 'Fichier Stock',
            adress: 'https://www.data.gouv.fr/en/datasets/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/',
            date_creation_stock: date_sirene_stock
          }
        },
        repertoire_national_metiers: {
          # TODO : change status / results when it will effectively return 404
          data: formatted_results_rnm,
          status: '200',
          metadata: {
            id: 'Répertoire National des Métiers',
            producteur: "Chambre de Métiers et de l'Artisanat",
            nature: 'API',
            adress: 'https://api-rnm.artisanat.fr/'
          }
        },
        computed: {
          data: {
            numero_tva_intra: numero_tva_for(@siren),
            geo: @result_siege_geo
          },
          metadata: {
            numero_tva_intra: {
              origin: "Computed by formula: 'FR' + '(12 + 3 * (siren % 97)) % 97' + 'siren'"
            },
            geo: {
              origin: 'Computed from SIRENE adresses via additional sources database',
              sources: 'Base Nationale Adresse (Data.gouv), Base Nationale Adresse Ouverte (OpenStreetMap France), Interest Points OpenStreetMap'
            }
          }
        }
      }
    end
    # rubocop:enable Metrics/MethodLength

    def data_from_sirene
      if !@result_siege.nil?
        {
          total_results: @results_sirets.size + 1,
          siege_social: @result_siege,
          other_etablissements_sirets: @results_sirets
        }
      else
        'etablissement not found in SIRENE database'
      end
    end

    def status_sirene
      return 200 unless @result_siege.nil?
      404
    end

    def date_sirene_stock
      name_stock = File.read(SaveLastMonthlyStockName.new.full_path)
      name_stock.split('/')[4]
    end

    # Complexify here when results_rnm will be returning other than empty hashes, so we dont get a JSON.parse error
    def formatted_results_rnm
      JSON.parse(@results_rnm)
    end

    def numero_tva_for(siren)
      tva_key =  (12 + 3 * (siren.to_i % 97)) % 97
      tva_number = tva_key.to_s + siren.to_s
      'FR' + tva_number
    end
  end
end
