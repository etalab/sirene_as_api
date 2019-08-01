class Etablissement < ApplicationRecord
  include Scopable::Model
  belongs_to :unite_legale, optional: true

  def self.header_mapping
    ETABLISSEMENT_HEADER_MAPPING
  end
end
