class Etablissement < ApplicationRecord
  attr_accessor :csv_path

  searchable do
    text :nom_raison_sociale
  end

  def self.latest_mise_a_jour
    self.limit(1).order('date_mise_a_jour DESC').first.date_mise_a_jour
  end
end
