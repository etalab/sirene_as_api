FactoryBot.define do
  factory :etablissement do |etablissement|
    sequence(:enseigne_1) { |n| "etablissement_#{n}" }
    sequence(:siret) { |n| "0000000000000#{n}" }

    factory :etablissement_with_unite_legale do
      transient do
        parent { create(:unite_legale) }
      end

      unite_legale { parent }
    end
  end
end
