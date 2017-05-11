# FactoryGirl.define do
#   sequence :siret do |n|
#     "person#{n}@example.com"
#   end
#   sequence :latest_mise_a_jour do |n|
#     "2017-01-0!T10:25:33"
# end

FactoryGirl.define do
  factory :etablissement do
    sequence(:siren) { |n| "11111#{n}" }
    sequence(:date_mise_a_jour, ('00'..'59').cycle) { |n| "2017-01-01!T10:25:#{n}" }
    nature_mise_a_jour ['C', 'D', 'I', 'F', 'E', 'O'].sample
  end
end
