# ADD constants about nature_mise_a_jour out of commercial diffusion for better simplicity

class Etablissement < ApplicationRecord
  attr_accessor :csv_path

  searchable do
    text :nom_raison_sociale
    text :libelle_activite_principale_entreprise
    text :libelle_commune
    text :l4_normalisee
    text :l2_normalisee
    text :sigle
    text :enseigne
    # Enseigne must be both string and text to use fulltext and faceting
    string :enseigne
    string :activite_principale
    string :code_postal
    string :nature_mise_a_jour
    string :is_ess
    string :nature_entrepreneur_individuel
    string :statut_prospection
    string :tranche_effectif_salarie_entreprise
    string :departement
    string :commune
    string :is_siege
    string :tranche_effectif_salarie_entreprise
    latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }
  end

  def self.latest_mise_a_jour
    # probabilist search for true latest update. Date time must be exact but a wrong time is tolerated
    # always works if at least one new entry had been inserted the previous day otherwise works well in most cases (>99.9% confidence)
    # 20 000 can be a good upper bound since every patch seems to have less than 20 000 lines
    last_update_nb_entries_tol = 20_000

    sql = "SELECT max(date_mise_a_jour)
           FROM (SELECT date_mise_a_jour FROM etablissements
                 ORDER BY id DESC
                 LIMIT #{last_update_nb_entries_tol}
           ) as x"

    ActiveRecord::Base.connection.exec_query(sql).first["max"]
  end

end
