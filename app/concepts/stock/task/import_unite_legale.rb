class Stock
  module Task
    class ImportUniteLegale < Trailblazer::Operation
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
        UniteLegale.import headers_mapping_unite_legale.values, chunk, validate: false
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
          downcase_header: false,
          convert_values_to_numeric: false,
          key_mapping: headers_mapping_unite_legale,
          remove_empty_values: false,
          file_encoding: 'UTF-8'
        }
      end

      def headers_mapping_unite_legale
        {
          siren: :siren,
          statutDiffusionUniteLegale: :statut_diffusion,
          unitePurgeeUniteLegale: :unite_purgee,
          dateCreationUniteLegale: :date_creation,
          sigleUniteLegale: :sigle,
          sexeUniteLegale: :sexe,
          prenom1UniteLegale: :prenom_1,
          prenom2UniteLegale: :prenom_2,
          prenom3UniteLegale: :prenom_3,
          prenom4UniteLegale: :prenom_4,
          prenomUsuelUniteLegale: :prenom_usuel,
          pseudonymeUniteLegale: :pseudonyme,
          identifiantAssociationUniteLegale: :identifiant_association,
          trancheEffectifsUniteLegale: :tranche_effectifs,
          anneeEffectifsUniteLegale: :annee_effectifs,
          dateDernierTraitementUniteLegale: :date_dernier_traitement,
          nombrePeriodesUniteLegale: :nombre_periodes,
          categorieEntreprise: :categorie_entreprise,
          anneeCategorieEntreprise: :annee_categorie_entreprise,
          dateDebut: :date_debut,
          etatAdministratifUniteLegale: :etat_administratif,
          nomUniteLegale: :nom,
          nomUsageUniteLegale: :nom_usage,
          denominationUniteLegale: :denomination,
          denominationUsuelle1UniteLegale: :denomination_usuelle_1,
          denominationUsuelle2UniteLegale: :denomination_usuelle_2,
          denominationUsuelle3UniteLegale: :denomination_usuelle_3,
          categorieJuridiqueUniteLegale: :categorie_juridique,
          activitePrincipaleUniteLegale: :activite_principale,
          nomenclatureActivitePrincipaleUniteLegale: :nomenclature_activite_principale,
          nicSiegeUniteLegale: :nic_siege,
          economieSocialeSolidaireUniteLegale: :economie_sociale_solidaire,
          caractereEmployeurUniteLegale: :caractere_employeur
        }
      end
    end
  end
end
