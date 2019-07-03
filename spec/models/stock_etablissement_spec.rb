require 'rails_helper'

describe StockEtablissement do
  specify '#logger_for_import' do
      expect(Logger).to receive(:new)
        .with(Rails.root.join('log', 'stock_etablissement.log'))

      described_class.new.logger_for_import
  end

  specify '::RELATED_MODEL' do
    expect(described_class::RELATED_MODEL).to be Etablissement
  end
end
