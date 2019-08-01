FactoryBot.define do
  factory :etablissement do |etablissement|
    sequence(:enseigne_1) { |n| "etablissement_#{n}" }
    sequence(:siret) { |n| "0000000000000#{n}" }
  end
end
