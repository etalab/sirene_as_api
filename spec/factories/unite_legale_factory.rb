FactoryBot.define do
  factory :unite_legale do
    sequence(:nom) { |n| "unite_legale_#{n}" }
    sequence(:siren) { |n| "00000000#{n}" }

    factory :unite_legale_with_2_etablissements do
      after(:create) do |unite_legale|
        create(:etablissement, unite_legale: unite_legale, etablissement_siege: 'true')
        create(:etablissement, unite_legale: unite_legale, etablissement_siege: 'false')
      end
    end
  end
end
