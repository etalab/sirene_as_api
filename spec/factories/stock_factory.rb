FactoryBot.define do
  factory :stock do
    uri { 'random/path' }
  end

  factory :stock_etablissement do
    year { '2019' }
    month { '06' }
    status { 'PENDING' }
    uri { 'random/path' }
  end

  factory :stock_unite_legale do
    year { '2019' }
    month { '06' }
    status { 'PENDING' }
    uri { 'random/path' }
  end
end
