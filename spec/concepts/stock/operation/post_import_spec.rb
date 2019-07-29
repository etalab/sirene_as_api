require 'rails_helper'

describe Stock::Operation::PostImport, :trb do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }
  let(:siren) { '005880034' }
  let!(:unite_legale) { create :unite_legale, siren: siren }
  let!(:etablissement) { create :etablissement, siren: siren }

  shared_examples 'not doing anything' do
    it { is_expected.to be_success }

    it 'logs other import not finished' do
      subject
      expect(logger).to have_received(:info).with('Other import not finished')
    end

    it 'does not create relationship' do
      subject
      expect(unite_legale.etablissements).to be_empty
      expect(etablissement.unite_legale).to be_nil
    end

    it 'does not create database indexes' do
      expect_not_to_call_nested_operation(Stock::Task::CreateIndexes)
      subject
    end
  end

  context 'when StockEtablissement is not COMPLETED' do
    before do
      create :stock_etablissement, :pending
      create :stock_unite_legale, :completed
    end

    it_behaves_like 'not doing anything'
  end

  context 'when StockUniteLegale is not completed' do
    before do
      create :stock_etablissement, :completed
      create :stock_unite_legale, :loading
    end

    it_behaves_like 'not doing anything'
  end

  context 'when StockUniteLegale does not exists' do
    it_behaves_like 'not doing anything'
  end

  context 'when StockEtablissement does not exists' do
    before { create :stock_unite_legale, :completed }

    it_behaves_like 'not doing anything'
  end

  context 'when both imports are COMPLETED' do
    before do
      create :stock_etablissement, :completed
      create :stock_unite_legale, :completed
    end

    it { is_expected.to be_success }

    it 'logs association starts' do
      subject
      expect(logger).to have_received(:info).with('Models associations starts')
    end

    it 'logs associations done' do
      subject
      expect(logger).to have_received(:info).with('Models associations completed')
    end

    it 'created the association' do
      subject
      unite_legale.reload
      etablissement.reload
      expect(unite_legale.etablissements.count).to eq 1
      expect(etablissement.unite_legale).to eq unite_legale
    end

    it 'creates database indexes' do
      expect_to_call_nested_operation(Stock::Task::CreateIndexes)
      subject
    end

    context 'when association failed' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:sql)
          .and_return 'an invalid SQL statement'
      end

      it { is_expected.to be_failure }

      it 'logs import starts' do
        subject
        expect(logger).to have_received(:info).with('Models associations starts')
      end

      it 'logs an error' do
        subject
        expect(logger).to have_received(:error).with(/Association failed:/)
      end

      it 'does not create database indexes' do
        expect_not_to_call_nested_operation(Stock::Task::CreateIndexes)
        subject
      end
    end
  end
end
