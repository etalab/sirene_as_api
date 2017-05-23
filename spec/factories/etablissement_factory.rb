#TODO: Check validation siren dans github SIAD
# Rappel : Mise a jour => Clef I/F
# Creation : C, Entŕee diffusion : D
# Suppression : E, Sortie diffusion : O

FactoryGirl.define do
  factory :etablissement do
    sequence(:siren) { |n| "11111#{n}" }
    sequence(:date_mise_a_jour, ('00'..'59').cycle) { |n| "2017-01-01T10:25:#{n}" }
    nature_mise_a_jour ["I", "F, ""C", "D", "E", "O"].sample
  end
end
