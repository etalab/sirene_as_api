class Stock
  module Task
    class Import < Trailblazer::Operation
      pass :log_import_start
      step :file_exists?
      fail :log_file_not_found, fail_fast: true
      step :create_progressbar
      step :process_csv
      pass :log_import_completed

      def file_exists?(_, csv:, **)
        File.exist? csv
      end

      def create_progressbar(ctx, csv:, **)
        ctx[:progress_bar] = ProgressBar.create(
          total: number_of_rows(csv),
          format: 'Progress %c/%C (%P %%) |%b>%i| %a %e'
        )
      end

      def process_csv(_, progress_bar:, csv:, logger:, **)
        SmarterCSV.process(csv, options) { |c| process_chunk(progress_bar, c) }
      rescue SmarterCSV::SmarterCSVException
        logger.error "Import failed, #{$ERROR_INFO.class}: #{$ERROR_INFO.message}"
        false
      end

      def log_import_start(_, csv:, logger:, **)
        logger.info "Import starting for file #{csv}"
      end

      def log_file_not_found(_, logger:, csv:, **)
        logger.error "File not found: #{csv}"
      end

      def log_import_completed(_, logger:, **)
        logger.info 'Import completed.'
      end

      private

      def process_chunk(progress_bar, chunk)
        EtablissementV3.import insee_headers, chunk, validate: false
        chunk.size.times { progress_bar.increment }
      end

      def number_of_rows(csv)
        `wc -l #{csv}`.split.first.to_i - 1
      end

      def options
        {
          chunk_size: 2_000,
          col_sep: ',',
          row_sep: "\n",
          convert_values_to_numeric: false,
          user_provided_headers: insee_headers,
          remove_empty_values: false,
          file_encoding: 'UTF-8'
        }
      end

      def insee_headers
        %i[
          siren
          nic
          siret
          statut_diffusion
          date_creation
          tranche_effectifs
          annee_effectifs
          activite_principale_registre_metiers
          date_dernier_traitement
          etablissement_siege
          nombre_periodes
          complement_adresse
          numero_voie
          indice_repetition
          type_voie
          libelle_voie
          code_postal
          libelle_commune
          libelle_commune_etranger
          distribution_speciale
          code_commune
          code_cedex
          libelle_cedex
          code_pays_etranger
          libelle_pays_etranger
          complement_adresse2
          numero_voie2
          indice_repetition2
          type_voie2
          libelle_voie2
          code_postal2
          libelle_commune2
          libelle_commune_etranger2
          distribution_speciale2
          code_commune2
          code_cedex2
          libelle_cedex2
          code_pays_etranger2
          libelle_pays_etranger2
          date_debut
          etat_administratif
          enseigne1
          enseigne2
          enseigne3
          denomination_usuelle
          activite_principale
          nomenclature_activite_principale
          caractere_employeur
          longitude
          latitude
          geo_score
          geo_type
          geo_adresse
          geo_id
          geo_ligne
          geo_l4
          geo_l5
        ]
      end
    end
  end
end
