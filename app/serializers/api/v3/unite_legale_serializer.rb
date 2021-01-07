class API::V3::UniteLegaleSerializer < ApplicationSerializer
  @model = UniteLegale

  attributes *all_fields

  has_many :etablissements

  attributes :etablissement_siege, :numero_tva_intra

  def etablissement_siege
    # `order(nil)` remove the default ordering on id that slow down the request
    # `limit` forces ActiveRecord to use the LIMIT statement (`.first` was supposed to do the same but not)
    object.etablissements.where(etablissement_siege: %w[true t]).order(nil).limit(1).first
  end
end
