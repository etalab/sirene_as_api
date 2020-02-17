require 'rails_helper'

describe Stock::Task::TruncateTable do
  subject { described_class.call table_name: 'etablissements', logger: logger }

  let(:logger) { instance_spy Logger }
  let(:siren) { '005880034' }

  before do
    unite_legale = create :unite_legale, siren: siren
    create :etablissement, siren: siren, unite_legale: unite_legale
  end

  context 'when it drops everything' do
    it { is_expected.to be_success }

    it 'has not deleted UniteLegale' do
      expect { subject }.not_to change(UniteLegale, :count)
    end

    it 'has deleted Etablissement' do
      expect { subject }.to change(Etablissement, :count).by(-1)
    end
  end

  context 'when it fails' do
    before do
      allow_any_instance_of(described_class)
        .to receive(:sql)
        .and_return 'invalid SQL statement'
    end

    it { is_expected.to be_failure }

    it 'logs an error' do
      subject
      expect(logger).to have_received(:error).with(/Truncate failed:/)
    end

    it 'has not deleted UniteLegale' do
      expect { subject }.not_to change(UniteLegale, :count)
    end

    it 'has not deleted Etablissment' do
      expect { subject }.not_to change(Etablissement, :count)
    end
  end
end
