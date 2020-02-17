FactoryBot.define do
  factory :etablissement do |_etablissement|
    sequence(:enseigne_1) { |n| "etablissement_#{n}" }
    sequence(:siren) { |n| "00000000#{n}" }
    sequence(:nic) { |n| "0000#{n}" }
    siret { siren + nic }
    statut_diffusion { 'O' }

    trait :non_diffusable do
      statut_diffusion { 'N' }
    end
  end
end
