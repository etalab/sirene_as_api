FactoryBot.define do
  factory :unite_legale do
    sequence(:nom) { |n| "unite_legale_#{n}" }
    sequence(:denomination) { |n| "denomination_#{n}" }
    sequence(:siren) { |n| "00000000#{n}" }
    statut_diffusion { 'O' }

    trait :non_diffusable do
      statut_diffusion { 'N' }
      date_dernier_traitement { '2016-11-30T14:31:01' }

      after :create do |unite_legale|
        create(:etablissement,
               unite_legale: unite_legale,
               siren: unite_legale.siren,
               etablissement_siege: 'true',
               date_dernier_traitement: '2016-11-30T14:31:01',
               statut_diffusion: 'N')
      end
    end

    factory :unite_legale_with_2_etablissements do
      after(:create) do |unite_legale|
        create(:etablissement, unite_legale: unite_legale, etablissement_siege: 'true')
        create(:etablissement, unite_legale: unite_legale, etablissement_siege: 'false')
      end
    end
  end
end
