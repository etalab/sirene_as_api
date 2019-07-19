require 'rails_helper'

describe Stock::Operation::PostImport do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }
  let(:siren) { '005880034' }
  let!(:unite_legale) { create :unite_legale, siren: siren }
  let!(:etablissement) { create :etablissement, siren: siren }

  before do
    create :stock_etablissement, year: '2019', month: '01', status: 'COMPLETED'
    create :stock_unite_legale,  year: '2019', month: '01', status: 'COMPLETED'
  end

  shared_examples 'not doing anything' do
    it { is_expected.to be_success }

    it 'does not create relationship' do
      subject
      expect(unite_legale.etablissements).to be_empty
      expect(etablissement.unite_legale).to be_nil
    end
  end

  context 'when StockEtablissement is not COMPLETED' do
    before do
      create :stock_etablissement, year: '2019', month: '02', status: 'PENDING'
      create :stock_unite_legale,  year: '2019', month: '02', status: 'COMPLETED'
    end

    it_behaves_like 'not doing anything'
  end

  context 'when StockUniteLegale is not completed' do
    before do
      create :stock_etablissement, year: '2019', month: '02', status: 'COMPLETED'
      create :stock_unite_legale,  year: '2019', month: '02', status: 'PENDING'
    end

    it_behaves_like 'not doing anything'
  end

  context 'when both imports are COMPLETED' do
    it { is_expected.to be_success }

    it 'created the association' do
      subject
      unite_legale.reload
      etablissement.reload
      expect(unite_legale.etablissements.count).to eq 1
      expect(etablissement.unite_legale).to eq unite_legale
    end

    context 'when association failed' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:sql)
          .and_return 'an invalid SQL statement'
      end

      it { is_expected.to be_failure }

      it 'logs an error' do
        subject
        expect(logger).to have_received(:error).with(/Association failed:/)
      end
    end
  end
end
