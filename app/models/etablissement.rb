class Etablissement < ApplicationRecord
  attr_accessor :csv_path

  searchable do
    text :nom_raison_sociale
  end
end
