require 'rails_helper'

describe API::V3::EtablissementsController do
  it_behaves_like 'scopable', :etablissement, :siret, :denomination_usuelle
end
