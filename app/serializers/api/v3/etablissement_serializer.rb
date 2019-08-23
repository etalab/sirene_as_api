class API::V3::EtablissementSerializer < ApplicationSerializer
  @model = Etablissement

  attributes *all_fields

  belongs_to :unite_legale
end
