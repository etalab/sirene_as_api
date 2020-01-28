require 'rails_helper'

describe Stock::Task::CreateAssociations do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }
  let(:siren) { '005880034' }

  let!(:unite_legale) do
    wrap_with_table_renamed(UniteLegale) do
      create :unite_legale, siren: siren
    end
  end

  let!(:etablissement) do
    wrap_with_table_renamed(Etablissement) do
      create :etablissement, siren: siren
    end
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

  it 'created the association for etablissement' do
    subject
    etab = Etablissement.new(
      get_raw_data('etablissements_tmp').first
    )
    expect(etab.unite_legale_id).to eq unite_legale.id
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
  end
end
