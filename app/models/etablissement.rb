class Etablissement < ApplicationRecord
  searchable do
    text :nom_raison_sociale
  end
end
