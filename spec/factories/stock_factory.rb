FactoryBot.define do
  factory :stock do
    of_june
    pending
    uri { 'random/path' }

    trait :of_last_year do
      year { '2018' }
      month { '10' }
    end

    trait :of_june do
      year { '2019' }
      month { '06' }
    end

    trait :of_july do
      year { '2019' }
      month { '07' }
    end

    trait :of_august do
      year { '2019' }
      month { '08' }
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

  factory :stock_etablissement, parent: :stock, class: StockEtablissement
  factory :stock_unite_legale, parent: :stock, class: StockUniteLegale
end
