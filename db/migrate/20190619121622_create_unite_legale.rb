class CreateUniteLegale < ActiveRecord::Migration[5.0]
  def change
    create_table :unites_legales do |t|
      t.string :siren
      t.string :statut_diffusion
      t.string :unite_purgee
      t.string :date_creation
      t.string :sigle
      t.string :sexe
      t.string :prenom_1
      t.string :prenom_2
      t.string :prenom_3
      t.string :prenom_4
      t.string :prenom_usuel
      t.string :pseudonyme
      t.string :identifiant_association
      t.string :tranche_effectifs
      t.string :annee_effectifs
      t.string :date_dernier_traitement
      t.string :nombre_periodes
      t.string :categorie_entreprise
      t.string :annee_categorie_entreprise
      t.string :date_fin
      t.string :date_debut
      t.string :etat_administratif
      t.string :nom
      t.string :nom_usage
      t.string :denomination
      t.string :denomination_usuelle_1
      t.string :denomination_usuelle_2
      t.string :denomination_usuelle_3
      t.string :categorie_juridique
      t.string :activite_principale
      t.string :nomenclature_activite_principale
      t.string :nic_siege
      t.string :economie_sociale_solidaire
      t.string :caractere_employeur

      t.timestamps
    end
  end
end
