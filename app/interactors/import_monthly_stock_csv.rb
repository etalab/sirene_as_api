class ImportMonthlyStockCsv < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log 'Starting csv import'
    stdout_info_log 'Computing number of rows'

    context.csv_filename = context.unzipped_files.first
    context.number_of_rows = `wc -l #{context.csv_filename}`.split.first.to_i - 1

    stdout_success_log "Found #{context.number_of_rows} rows to import"

    stdout_info_log 'Importing rows'
    quietly do
      stdout_etablissement_count_change do
        stdout_benchmark_stats do
          interactor.call
        end
      end
    end

    puts
  end

  def call
    unless clean_database?
      stdout_error_log("Database not empty.
        Please run 'bundle exec rake sirene_as_api:delete_database' before populating.")
      context.fail!(error: 'database should be empty before importing a stock file')
      return
    end
    progress_bar = create_progressbar(context)

    process_csv_job(context, progress_bar)
  end

  def clean_database?
    EtablissementV2.first.nil?
  end

  def create_progressbar(context)
    ProgressBar.create(
      total: context.number_of_rows,
      format: 'Progress %c/%C (%P %%) |%b>%i| %a %e'
    )
  end

  def process_csv_job(context, progress_bar)
    SmarterCSV.process(context.csv_filename, csv_options) do |chunk|
      InsertEtablissementRowsJob.new(chunk).perform
      chunk.size.times { progress_bar.increment }
    end
  end

  def csv_options
    {
      chunk_size: 2_000,
      col_sep: ',',
      row_sep: "\n",
      header_transformations: [key_mapping: key_mapping_v2]
    }
  end

  def quietly
    ar_log_level_before_block_execution = ActiveRecord::Base.logger.level
    log_level_before_block_execution = Rails.logger.level

    Rails.logger.level = :fatal
    ActiveRecord::Base.logger.level = :error
    yield
    Rails.logger.level = log_level_before_block_execution
    ActiveRecord::Base.logger.level = ar_log_level_before_block_execution
  end

  def stdout_etablissement_count_change
    etablissement_count_before = EtablissementV2.count
    yield
    etablissement_count_after = EtablissementV2.count

    entries_added = etablissement_count_after - etablissement_count_before

    puts "#{entries_added} etablissements added"
  end

  def stdout_benchmark_stats
    Benchmark.bm(7) do |x|
      x.report(:csv_pro) do
        yield
      end
    end
  end

  def key_mapping_v2
    {
      numvoie: :numero_voie,
      indrep: :indice_repetition,
      typvoie: :type_voie,
      libvoie: :libelle_voie,
      codpos: :code_postal,
      rpet: :region,
      libreg: :libelle_region,
      depet: :departement,
      arronet: :arrondissement,
      ctonet: :canton,
      comet: :commune,
      libcom: :libelle_commune,
      du: :departement_unite_urbaine,
      tu: :taille_unite_urbaine,
      uu: :numero_unite_urbaine,
      epci: :etablissement_public_cooperation_intercommunale,
      tcd: :tranche_commune_detaillee,
      zemet: :zone_emploi,
      siege: :is_siege,
      ind_publipo: :indicateur_champ_publipostage,
      diffcom: :statut_prospection,
      amintret: :date_introduction_base_diffusion,
      natetab: :nature_entrepreneur_individuel,
      libnatetab: :libelle_nature_entrepreneur_individuel,
      apet700: :activite_principale,
      libapet: :libelle_activite_principale,
      dapet: :date_validite_activite_principale,
      tefet: :tranche_effectif_salarie,
      libtefet: :libelle_tranche_effectif_salarie,
      efetcent: :tranche_effectif_salarie_centaine_pret,
      defet: :date_validite_effectif_salarie,
      origine: :origine_creation,
      dcret: :date_creation,
      ddebact: :date_debut_activite,
      activnat: :nature_activite,
      lieuact: :lieu_activite,
      actisurf: :type_magasin,
      saisonat: :is_saisonnier,
      modet: :modalite_activite_principale,
      prodet: :caractere_productif,
      prodpart: :participation_particuliere_production,
      auxilt: :caractere_auxiliaire,
      nomen_long: :nom_raison_sociale,
      rna: :numero_rna,
      nicsiege: :nic_siege,
      rpen: :region_siege,
      depcomen: :departement_commune_siege,
      adr_mail: :email,
      nj: :nature_juridique_entreprise,
      libnj: :libelle_nature_juridique_entreprise,
      apen700: :activite_principale_entreprise,
      libapen: :libelle_activite_principale_entreprise,
      dapen: :date_validite_activite_principale_entreprise,
      aprm: :activite_principale_registre_metier,
      ess: :is_ess,
      dateess: :date_ess,
      tefen: :tranche_effectif_salarie_entreprise,
      libtefen: :libelle_tranche_effectif_salarie_entreprise,
      efencent: :tranche_effectif_salarie_entreprise_centaine_pret,
      defen: :date_validite_effectif_salarie_entreprise,
      categorie: :categorie_entreprise,
      dcren: :date_creation_entreprise,
      amintren: :date_introduction_base_diffusion_entreprise,
      monoact: :indice_monoactivite_entreprise,
      moden: :modalite_activite_principale_entreprise,
      proden: :caractere_productif_entreprise,
      esaann: :date_validite_rubrique_niveau_entreprise_esa,
      tca: :tranche_chiffre_affaire_entreprise_esa,
      esaapen: :activite_principale_entreprise_esa,
      esasec1n: :premiere_activite_secondaire_entreprise_esa,
      esasec2n: :deuxieme_activite_secondaire_entreprise_esa,
      esasec3n: :troisieme_activite_secondaire_entreprise_esa,
      esasec4n: :quatrieme_activite_secondaire_entreprise_esa,
      vmaj: :nature_mise_a_jour,
      vmaj1: :indicateur_mise_a_jour_1,
      vmaj2: :indicateur_mise_a_jour_2,
      vmaj3: :indicateur_mise_a_jour_3,
      datemaj: :date_mise_a_jour
    }
  end
end
