FactoryBot.define do
  factory :stock do
    year { '2019' }
    month { '06' }
    status { 'PENDING' }
    uri { 'random/path' }
  end
end
