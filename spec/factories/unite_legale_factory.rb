FactoryBot.define do
  factory :unite_legale do
    sequence(:nom) { |n| "unite_legale_#{n}" }
    sequence(:siren) { |n| "00000000#{n}" }
  end
end