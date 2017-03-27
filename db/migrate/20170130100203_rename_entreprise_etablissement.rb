class RenameEntrepriseEtablissement < ActiveRecord::Migration[5.0]
  def self.up
    rename_table :entreprises, :etablissements
  end

  def self.down
    rename_table :etablissements, :entreprises
  end
end
