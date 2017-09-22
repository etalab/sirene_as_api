class RenameLibelleToLibelleRegion < ActiveRecord::Migration[5.0]
  def change
    rename_column :etablissements, :libelle, :libelle_region
  end
end
