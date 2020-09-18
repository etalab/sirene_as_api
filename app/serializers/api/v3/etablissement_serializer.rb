class API::V3::EtablissementSerializer < ApplicationSerializer
  @model = Etablissement

  attributes *all_fields

  belongs_to :unite_legale

  def etablissement_siege
    if ['true', 't'].include?(object.etablissement_siege)
      true
    elsif ['false', 'f'].include?(object.etablissement_siege)
      false
    end
  end
end
