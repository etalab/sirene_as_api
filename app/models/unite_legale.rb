class UniteLegale < ApplicationRecord
  include Scopable::Model

  has_many :etablissements

  def self.header_mapping
    UNITE_LEGALE_HEADER_MAPPING
  end
end
