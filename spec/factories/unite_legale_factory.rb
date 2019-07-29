FactoryBot.define do
  factory :unite_legale do
    sequence(:nom) { |n| "unite_legale_#{n}" }
    sequence(:siren) { |n| "00000000#{n}" }

    factory :unite_legale_with_etablissements do
      transient do
        etablissements_count { 3 }
      end

      after(:create) do |unite_legale, evaluator|
        create_list(:etablissement, evaluator.etablissements_count, unite_legale: unite_legale)
      end
    end
  end
end
