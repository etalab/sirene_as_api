class API::V3::UniteLegaleSerializer < ApplicationSerializer
  @model = UniteLegale

  attributes *all_fields

  has_many :etablissements

  attribute :etablissement_siege

  def etablissement_siege
    object.etablissements.where(etablissement_siege: ['true', 't']).order(nil).limit(1).first
  end
end
