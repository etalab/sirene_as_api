#TODO: Check validation siren dans github SIAD

FactoryGirl.define do
  factory :etablissement do
    sequence(:siren) { |n| "11111#{n}" }
    sequence(:date_mise_a_jour, ('00'..'59').cycle) { |n| "2017-01-01T10:25:#{n}" }
  end
end
