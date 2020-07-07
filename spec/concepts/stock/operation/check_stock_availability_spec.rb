require 'rails_helper'

describe Stock::Operation::CheckStockAvailability, :trb, vcr: { cassette_name: 'check_stock_availability' } do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  context 'when both stock files are available' do
    it { is_expected.to be_success }
  end

  context 'when stock unites legales is not reachable' do
    before do
      allow_any_instance_of(StockUniteLegale).to receive(:uri).and_return('http://files.data.gouv.fr/insee-sirene/FILE_NOT_FOUND.zip')
    end

    it { is_expected.to be_failure }

    it 'logs a warning' do
      subject
      expect(logger)
        .to have_received(:warn)
        .with('Stock unites legales not reachable')
    end
  end

  context 'when stock file etablissements is not reachable' do
    before do
      allow_any_instance_of(StockEtablissement).to receive(:uri).and_return('https://files.data.gouv.fr/geo-sirene/2222-22/FILE_NOT_FOUND.zip')
    end

    it { is_expected.to be_failure }

    it 'logs a warning' do
      subject
      expect(logger)
        .to have_received(:warn)
        .with('Stock etablissements not reachable')
    end
  end
end
