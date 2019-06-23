class RenameEtablissement < ActiveRecord::Migration[5.0]
  def self.up
    rename_table :etablissements, :etablissements_v2
  end

  def self.down
    rename_table :etablissements_v2, :etablissements
  end
end
