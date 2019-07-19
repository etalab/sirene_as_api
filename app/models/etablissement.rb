class Etablissement < ApplicationRecord
  belongs_to :unite_legale, optional: true

  def self.header_mapping
    ETABLISSEMENT_HEADER_MAPPING
  end
end
