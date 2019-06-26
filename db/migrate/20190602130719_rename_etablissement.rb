class RenameEtablissement < ActiveRecord::Migration[5.0]
  def change
    rename_table :etablissements, :etablissements_v2
  end
end
