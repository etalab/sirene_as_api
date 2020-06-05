# TODO: Check validation siren dans github SIAD
# Rappel : Mise a jour => Clef I/F
# Creation : C, Entree diffusion : D
# Suppression : E, Sortie diffusion : O

FactoryBot.define do
  factory :etablissement_v2 do
    sequence(:nom) { |n| "entreprise#{n}" }
    sequence(:siren) { |n| "11111#{n}" }
    sequence(:date_mise_a_jour, ('00'..'59').cycle) { |n| "2017-01-01T10:25:#{n}" }
    nature_mise_a_jour { %w[I F C D].sample }
    code_postal { %w[92600 75015 34000 93000 55055 07300].cycle }
  end
end
