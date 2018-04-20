class AddGeocodedColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :etablissements, :longitude,   :string
    add_column :etablissements, :latitude,    :string
    add_column :etablissements, :geo_score,   :string
    add_column :etablissements, :geo_type,    :string
    add_column :etablissements, :geo_adresse, :string
    add_column :etablissements, :geo_id,      :string
    add_column :etablissements, :geo_ligne,   :string
  end
end