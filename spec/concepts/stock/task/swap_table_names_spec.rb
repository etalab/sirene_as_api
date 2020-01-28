require 'rails_helper'

describe Stock::Task::SwapTableNames do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  let!(:unite_legale) { create :unite_legale, siren: 'normal' }
  let!(:etablissement) { create :etablissement, siret: 'normal' }

  let!(:unite_legale_tmp) do
    wrap_with_table_renamed(UniteLegale) do
      create :unite_legale, siren: 'temp'
    end
  end

  let!(:etablissement_tmp) do
    wrap_with_table_renamed(Etablissement) do
      create :etablissement, siret: 'temp'
    end
  end

  example 'temp UniteLegale is now live' do
    subject
    expect(UniteLegale.first).to eq unite_legale_tmp
  end

  example 'old UniteLegale is now in temp table' do
    subject
    raw_unite_legale = UniteLegale.new(
      get_raw_data('unites_legales_tmp').first
    )

    expect(raw_unite_legale).to eq unite_legale
  end

  it { is_expected.to be_success }

  example 'temp Etablissement is now live' do
    subject
    expect(Etablissement.first).to eq etablissement_tmp
  end

  example 'old Etablissement is now in temp table' do
    subject
    raw_etablissement = Etablissement.new(
      get_raw_data('etablissements_tmp').first
    )

    expect(raw_etablissement).to eq etablissement
  end

  it 'logs renaming messages' do
    subject
    expect(logger)
      .to have_received(:info)
      .with('Table renaming starts')
      .ordered

    expect(logger)
      .to have_received(:info)
      .with('Table renaming done')
      .ordered
  end
end
