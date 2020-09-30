class API::V3::EtablissementSerializer < ApplicationSerializer
  @model = Etablissement

  attributes *all_fields

  belongs_to :unite_legale

  # rubocop:disable Style/EmptyElse
  def etablissement_siege
    if %w[true t].include?(object.etablissement_siege)
      'true'
    elsif %w[false f].include?(object.etablissement_siege)
      'false'
    else
      nil
    end
  end
  # rubocop:enable Style/EmptyElse
end
