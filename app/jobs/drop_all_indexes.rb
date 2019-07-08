class DropAllIndexes < SireneAsAPIInteractor

  def call
    indexes_to_be_removed.each do |index|
      stdout_info_log("Trying to drop index : #{index}")
      ActiveRecord::Base.connection.execute("DROP INDEX CONCURRENTLY IF EXISTS #{index}")
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
     index_etablissements_on_siren
     index_etablissements_on_siret
    )
  end

end
