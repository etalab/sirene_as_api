class Etablissement < ApplicationRecord
  include Scopable::Model
  belongs_to :unite_legale, optional: true

  AUTHORIZED_FIELDS = %w[id siret nic siren statut_diffusion unite_legale unite_legale_id date_dernier_traitement created_at updated_at].freeze

  def self.header_mapping
    ETABLISSEMENT_HEADER_MAPPING
  end

  def nullify_non_diffusable_fields
    return if statut_diffusion == 'O'

    attributes.keys.each do |attribute|
      send("#{attribute}=", nil) unless AUTHORIZED_FIELDS.include?(attribute)
    end
  end
end
