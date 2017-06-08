#TODO: Check validation siren dans github SIAD
# Rappel : Mise a jour => Clef I/F
# Creation : C, Entŕee diffusion : D
# Suppression : E, Sortie diffusion : O

FactoryGirl.define do
  factory :etablissement do
    sequence(:nom) {|n| "entreprise#{n}" }
    sequence(:siren) { |n| "11111#{n}" }
    sequence(:date_mise_a_jour, ('00'..'59').cycle) { |n| "2017-01-01T10:25:#{n}" }
    nature_mise_a_jour ["I", "F, ""C", "D"].sample
    activite_principale ["APE1", "APE2", "APE3", "APE4", "APE5", "APE6"].sample
    code_postal ["92600", "75015", "34000", "93000", "55055", "07300"].sample
  end
end
