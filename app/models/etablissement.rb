# Class Etablissement

class Etablissement < ApplicationRecord
  attr_accessor :csv_path
  scope :in_commercial_diffusion, -> { where(nature_mise_a_jour: ["I", "F, ""C", "D"]) }

  searchable do
    text :nom_raison_sociale
    string :activite_principale
    string :code_postal
  end

  def self.latest_mise_a_jour
    latest_entry.try(:date_mise_a_jour)
  end

  def self.latest_entry
    unscoped.limit(1).order('date_mise_a_jour DESC').first
  end
end
