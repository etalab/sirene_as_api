FactoryBot.define do
  factory :daily_update do
    pending
    from { Time.zone.local(2020, 1, 1) }
    to { Time.zone.local(2020, 1, 19) }

    trait :pending do
      status { 'PENDING' }
    end

    trait :loading do
      status { 'LOADING' }
    end

    trait :errored do
      status { 'ERROR' }
    end

    trait :completed do
      status { 'COMPLETED' }
    end
  end

  factory :daily_update_unite_legale, parent: :daily_update, class: DailyUpdateUniteLegale
  factory :daily_update_etablissement, parent: :daily_update, class: DailyUpdateEtablissement
  factory :daily_update_unite_legale_non_diffusable, parent: :daily_update, class: DailyUpdateUniteLegaleNonDiffusable
  factory :daily_update_etablissement_non_diffusable, parent: :daily_update, class: DailyUpdateEtablissementNonDiffusable
end
