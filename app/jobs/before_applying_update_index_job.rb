class BeforeApplyingUpdateIndexJob < SireneAsAPIInteractor

  def call

    unless context.links.size <= 5
      stdout_warn_log("Dropping indexes to speed up patches update")
      stdout_warn_log("The queries might be slower than usual !")

      indexes_to_be_removed.each do |index|
        stdout_info_log("Trying to drop index : #{index}")
        ActiveRecord::Base.connection.execute("DROP INDEX CONCURRENTLY IF EXISTS #{index}")
      end
      stdout_success_log("Indexes dropped")
      
      indexes_needed_if_not_exists_queries.each do |query|
        stdout_info_log("Executing : #{query}")
        ActiveRecord::Base.connection.execute(query)
      end
    end

  end

  def indexes_to_be_removed
    %w(
     entreprises_to_tsvector_idx
     entreprises_to_tsvector_idx1
     entreprises_to_tsvector_idx2
     entreprises_to_tsvector_idx3
     entreprises_to_tsvector_idx4
     etablissements_to_tsvector_idx
     index_etablissements_on_activite_principale
     index_etablissements_on_l6_normalisee
     index_etablissements_on_nom_raison_sociale
     index_etablissements_on_numero_rna
    )
  end

  def indexes_needed_if_not_exists_queries
    [
      "CREATE INDEX CONCURRENTLY IF NOT EXISTS index_etablissements_on_siret ON etablissements USING btree (siret)",
      "CREATE INDEX CONCURRENTLY IF NOT EXISTS index_etablissements_on_siren ON public.etablissements USING btree (siren)"
    ]
  end


end
