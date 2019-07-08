class AfterApplyingUpdateIndexJob < SireneAsAPIInteractor

  def call
    stdout_warn_log("Creating necessary indexes for database")

    indexes_to_add_queries.each do |query|
      stdout_info_log("Executing : #{query}")
      ActiveRecord::Base.connection.execute(query)
    end

    stdout_success_log("Created indexes for database")
  end

  def indexes_to_add_queries
    ["CREATE INDEX CONCURRENTLY IF NOT EXISTS index_etablissements_on_siret ON public.etablissements USING btree (siret)",
     "CREATE INDEX CONCURRENTLY IF NOT EXISTS index_etablissements_on_siren ON public.etablissements USING btree (siren)",
     "CREATE INDEX CONCURRENTLY IF NOT EXISTS entreprises_to_tsvector_idx ON public.etablissements USING gin (to_tsvector('french'::regconfig, (siren)::text))",
     "CREATE INDEX CONCURRENTLY IF NOT EXISTS entreprises_to_tsvector_idx1 ON public.etablissements USING gin (to_tsvector('french'::regconfig, (siret)::text))",
     "CREATE INDEX CONCURRENTLY IF NOT EXISTS entreprises_to_tsvector_idx2 ON public.etablissements USING gin (to_tsvector('french'::regconfig, (activite_principale)::text))",
     "CREATE INDEX CONCURRENTLY IF NOT EXISTS entreprises_to_tsvector_idx3 ON public.etablissements USING gin (to_tsvector('french'::regconfig, (l6_normalisee)::text))",
     "CREATE INDEX CONCURRENTLY IF NOT EXISTS entreprises_to_tsvector_idx4 ON public.etablissements USING gin (to_tsvector('french'::regconfig, (nom_raison_sociale)::text))",
     "CREATE INDEX CONCURRENTLY IF NOT EXISTS etablissements_to_tsvector_idx ON public.etablissements USING gin (to_tsvector('french'::regconfig, (numero_rna)::text))",
     "CREATE INDEX CONCURRENTLY IF NOT EXISTS query_etablissements_on_activite_principale ON public.etablissements USING btree (activite_principale)",
     "CREATE INDEX CONCURRENTLY IF NOT EXISTS index_etablissements_on_l6_normalisee ON public.etablissements USING btree (l6_normalisee)",
     "CREATE INDEX CONCURRENTLY IF NOT EXISTS index_etablissements_on_nom_raison_sociale ON public.etablissements USING btree (nom_raison_sociale)",
     "CREATE INDEX CONCURRENTLY IF NOT EXISTS index_etablissements_on_numero_rna ON public.etablissements USING btree (numero_rna)"
    ]
  end
end