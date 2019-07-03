require 'rails_helper'

describe StockUniteLegale do
  subject { described_class.new }

  specify '#logger_for_import' do
      expect(Logger).to receive(:new)
        .with(Rails.root.join('log', 'stock_unite_legale.log'))

      subject.logger_for_import
  end

  specify '::RELATED_MODEL' do
    expect(described_class::RELATED_MODEL).to be UniteLegale
  end
end
