FactoryBot.define do
  factory :etablissement do |_etablissement|
    sequence(:enseigne_1) { |n| "enseigne_#{n}" }
    sequence(:siren) { |n| "00000000#{n}" }
    sequence(:nic) { |n| "0000#{n}" }
    siret { siren + nic }
    statut_diffusion { 'O' }
    date_dernier_traitement { '2016-11-30T14:31:01' }

    trait :non_diffusable do
      statut_diffusion { 'N' }
    end
  end
end
