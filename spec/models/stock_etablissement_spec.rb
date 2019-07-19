require 'rails_helper'

describe StockEtablissement do
  it_behaves_like 'having correct log filename', 'stock_etablissement.log'
  it_behaves_like 'having related model', Etablissement
end
