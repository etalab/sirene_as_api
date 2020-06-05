class UniteLegale < ApplicationRecord
  include Scopable::Model

  has_many :etablissements

  AUTHORIZED_FIELDS = %w[id siren statut_diffusion etablissements date_dernier_traitement created_at updated_at].freeze

  def self.header_mapping
    UNITE_LEGALE_HEADER_MAPPING
  end

  def nullify_non_diffusable_fields
    return if statut_diffusion == 'O'

    attributes.each_key do |attribute|
      send("#{attribute}=", nil) unless AUTHORIZED_FIELDS.include?(attribute)
    end
  end
end
