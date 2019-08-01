require 'rails_helper'

describe StockUniteLegale do
  it_behaves_like 'having correct log filename', 'stock_unite_legale.log'
  it_behaves_like 'having related model', UniteLegale
end
