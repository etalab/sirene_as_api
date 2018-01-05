require 'rails_helper'

def populate_database_before_test
  before :each do
    populate_test_database_with_5
  end
end

def populate_test_database_with_5
  5.times do
    create(:etablissement, nom_raison_sociale: 'foobarcompany')
  end
end

def populate_test_database_with_4_only_diffusion
  %w[I F C D].cycle(1) do |x|
    create(:etablissement, nom_raison_sociale: 'foobarcompany', nature_mise_a_jour: x)
  end
end

def populate_test_database_with_3_no_diffusion
  %w[O E].cycle(1) do |x|
    create(:etablissement, nom_raison_sociale: 'foobarcompany', nature_mise_a_jour: x)
  end
  create(:etablissement, nom_raison_sociale: 'foobarcompany', statut_prospection: 'N')
end

def populate_test_database_with_6_all
  %w[I F C D E O].cycle(1) do |x|
    create(:etablissement, nom_raison_sociale: 'foobarcompany', nature_mise_a_jour: x)
  end
end
