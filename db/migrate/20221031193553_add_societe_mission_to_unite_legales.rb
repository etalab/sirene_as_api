class AddSocieteMissionToUniteLegales < ActiveRecord::Migration[5.0]
  def change
    add_column :unites_legales, :societe_mission, :string
    add_column :unites_legales_tmp, :societe_mission, :string
  end
end
