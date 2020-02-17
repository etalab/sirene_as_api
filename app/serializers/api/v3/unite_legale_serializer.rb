class API::V3::UniteLegaleSerializer < ApplicationSerializer
  @model = UniteLegale

  attributes *all_fields

  has_many :etablissements

  attribute :etablissement_siege

  AUTHORIZED_FIELDS = %w[id siren statut_diffusion etablissements date_dernier_traitement created_at updated_at].freeze

  def initialize(object, options = {})
    clean_unauthorized_fields(object) if object.statut_diffusion == 'N'
    super
  end

  def etablissement_siege
    siege = object.etablissements.where(etablissement_siege: 'true').first
    API::V3::EtablissementSerializer.new(siege, without_association: true).as_json.symbolize_keys unless siege.nil?
  end

  private

  def clean_unauthorized_fields(object)
    object.attributes.keys.each do |attribute|
      object.send("#{attribute}=", nil) unless AUTHORIZED_FIELDS.include?(attribute)
    end
  end
end
