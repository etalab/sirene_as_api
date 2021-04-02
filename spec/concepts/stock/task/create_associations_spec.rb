require 'rails_helper'

describe Stock::Task::CreateAssociations, use_transactional_fixtures: false do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }
  let(:siren_1) { '005880034' }
  let(:siren_2) { '005880035' }
  let(:siren_3) { '005880036' }

  let!(:unite_legale) do
    wrap_with_table_renamed(UniteLegale) do
      create :unite_legale, siren: siren_1
      create :unite_legale, siren: siren_2
      create :unite_legale, siren: siren_3
    end
  end

  let!(:etablissement) do
    wrap_with_table_renamed(Etablissement) do
      create :etablissement, siren: siren_1
      create :etablissement, siren: siren_2
      create :etablissement, siren: siren_3
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
      get_raw_data('etablissements_tmp').find { |e| e['siren'] == siren_1 }
    )
    entreprise = UniteLegale.new(
      get_raw_data('unites_legales_tmp').find { |u| u['siren'] == siren_1 }
    )
    expect(etab.unite_legale_id).to eq entreprise.id
  end

  it 'should have done 2 loop for the associations' do
    allow_any_instance_of(described_class).to receive(:request_limit).and_return 2
    subject
    expect(subject[:loop_count]).to eq 2
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
