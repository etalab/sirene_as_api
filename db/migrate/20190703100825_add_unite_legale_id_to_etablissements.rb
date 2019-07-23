class AddUniteLegaleIdToEtablissements < ActiveRecord::Migration[5.0]
  def change
    add_column :etablissements, :unite_legale_id, :integer
  end
end
