class UniteLegale < ApplicationRecord
  include PgSearch::Model
  include Scopable::Model

  has_many :etablissements

  multisearchable against: [:denomination, :siren]
  scope :full_text_search_for, -> (term) do
    joins(:pg_search_document).merge(
      PgSearch.multisearch(term).where(searchable_type: klass.to_s)
    )
  end

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

  def numero_tva_intra
    tva_key =  (12 + 3 * (siren.to_i % 97)) % 97
    padded_key = tva_key.to_s.rjust(2, '0')
    tva_number = padded_key + siren.to_s
    "FR#{tva_number}"
  end
end
