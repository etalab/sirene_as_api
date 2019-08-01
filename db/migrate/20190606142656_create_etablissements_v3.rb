class CreateEtablissementsV3 < ActiveRecord::Migration[5.0]
  def change
    create_table :etablissements do |t|
      t.string :siren
      t.string :nic
      t.string :siret
      t.string :statut_diffusion
      t.string :date_creation
      t.string :tranche_effectifs
      t.string :annee_effectifs
      t.string :activite_principale_registre_metiers
      t.string :date_dernier_traitement
      t.string :etablissement_siege
      t.string :nombre_periodes
      t.string :complement_adresse
      t.string :numero_voie
      t.string :indice_repetition
      t.string :type_voie
      t.string :libelle_voie
      t.string :code_postal
      t.string :libelle_commune
      t.string :libelle_commune_etranger
      t.string :distribution_speciale
      t.string :code_commune
      t.string :code_cedex
      t.string :libelle_cedex
      t.string :code_pays_etranger
      t.string :libelle_pays_etranger
      t.string :complement_adresse_2
      t.string :numero_voie_2
      t.string :indice_repetition_2
      t.string :type_voie_2
      t.string :libelle_voie_2
      t.string :code_postal_2
      t.string :libelle_commune_2
      t.string :libelle_commune_etranger_2
      t.string :distribution_speciale_2
      t.string :code_commune_2
      t.string :code_cedex_2
      t.string :libelle_cedex_2
      t.string :code_pays_etranger_2
      t.string :libelle_pays_etranger_2
      t.string :date_debut
      t.string :etat_administratif
      t.string :enseigne_1
      t.string :enseigne_2
      t.string :enseigne_3
      t.string :denomination_usuelle
      t.string :activite_principale
      t.string :nomenclature_activite_principale
      t.string :caractere_employeur
      t.string :longitude
      t.string :latitude
      t.string :geo_score
      t.string :geo_type
      t.string :geo_adresse
      t.string :geo_id
      t.string :geo_ligne
      t.string :geo_l4
      t.string :geo_l5
      t.timestamps
    end
    add_index :etablissements, :siren
    add_index :etablissements, :siret, unique: true
  end
end
