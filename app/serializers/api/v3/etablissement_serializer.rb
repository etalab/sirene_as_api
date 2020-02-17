class API::V3::EtablissementSerializer < ApplicationSerializer
  @model = Etablissement

  attributes *all_fields

  belongs_to :unite_legale, if: :with_association?

  AUTHORIZED_FIELDS = %w[id siret nic siren statut_diffusion unite_legale date_dernier_traitement created_at updated_at].freeze

  def initialize(object, options = {})
    clean_unauthorized_fields(object) if object.statut_diffusion == 'N'
    super
  end

  def with_association?
    !instance_options[:without_association]
  end

  private

  def clean_unauthorized_fields(object)
    object.attributes.keys.each do |attribute|
      object.send("#{attribute}=", nil) unless AUTHORIZED_FIELDS.include?(attribute)
    end
  end
end
