class FilesFromV3 < ActiveRecord::Migration[5.0]
  def change
      remove_column :etablissements, :type_creation, :string
      remove_column :etablissements, :date_reactivation_etablissement, :string
      remove_column :etablissements, :date_reactivation_entreprise, :string
      remove_column :etablissements, :indicateur_mise_a_jour_enseigne_entreprise, :string
      remove_column :etablissements, :indicateur_mise_a_jour_activite_principale_etablissement, :string
      remove_column :etablissements, :indicateur_mise_a_jour_adresse_etablissement, :string
      remove_column :etablissements, :indicateur_mise_a_jour_caractere_productif_etablissement, :string
      remove_column :etablissements, :indicateur_mise_a_jour_caractere_auxiliaire_etablissement, :string
      remove_column :etablissements, :indicateur_mise_a_jour_nom_raison_sociale, :string
      remove_column :etablissements, :indicateur_mise_a_jour_sigle, :string
      remove_column :etablissements, :indicateur_mise_a_jour_nature_juridique, :string
      remove_column :etablissements, :indicateur_mise_a_jour_activite_principale_entreprise, :string
      remove_column :etablissements, :indicateur_mise_a_jour_caractere_productif_entreprise, :string
      remove_column :etablissements, :indicateur_mise_a_jour_nic_siege, :string
      remove_column :etablissements, :siret_predecesseur_successeur, :string
      remove_column :etablissements, :telephone, :string

      add_column :etablissements, :geo_l4, :string
      add_column :etablissements, :geo_l5, :string
  end
end
