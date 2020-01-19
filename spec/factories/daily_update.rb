FactoryBot.define do
  factory :daily_update do
    pending
    from { Time.new(2020, 1, 1) }
    to { Time.new(2020, 1, 19) }

    trait :for_etablissement do
      model_name_to_update { 'etablissement' }
    end

    trait :for_unite_legale do
      model_name_to_update { 'unite_legale' }
    end

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
end
