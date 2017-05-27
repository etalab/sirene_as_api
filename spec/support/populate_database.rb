require 'rails_helper'

def populate_database_before_test
  before :each do
    puts 'Populating the database before test...'
    populate_test_database
  end
end

def populate_test_database
  50.times do
    create(:etablissement)
  end
end

def populate_test_database_with_only_diffusion
  50.times do
    create(:etablissement, nature_mise_a_jour: ["I", "F, ""C", "D", "E"].sample)
  end
end

def populate_test_database_with_no_diffusion
  20.times do
    create(:etablissement, nature_mise_a_jour: "O")
  end
end

def populate_test_database_with_all
  100.times do
    create(:etablissement, nature_mise_a_jour: ["I", "F, ""C", "D", "E", "O"].sample)
  end
end
