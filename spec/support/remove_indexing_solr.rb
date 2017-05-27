# TODO: Factorise for not having to copy model Etablissement every time
class Etablissement < ApplicationRecord
  attr_accessor :csv_path
  default_scope -> { where(nature_mise_a_jour: ["I", "F, ""C", "D", "E"]) }

  searchable do
    text :nom_raison_sociale
  end
  # searchable auto_remove: false, auto_index: false do
  #   text :nom_raison_sociale
  # end
  # private
  # def perform_index_tasks
  #   nil
  # end
  def self.latest_mise_a_jour
    latest_entry.date_mise_a_jour
  end

  def self.latest_entry
    limit(1).order('date_mise_a_jour DESC').first
  end
end
