require 'rails_helper'

describe DailyUpdate::Task::AdaptUniteLegale do
  subject { described_class.call result: unite_legale_insee }

  let(:fixture_path) { 'spec/fixtures/samples_insee/unite_legale.json' }
  let(:unite_legale_insee) do
    JSON.parse(
      File.read(fixture_path),
      symbolize_names: true
    )
  end

  let(:keys_to_ignore) { %i[id unite_purgee created_at updated_at] }
  let(:expected_keys) do
    UniteLegale
      .new
      .attributes
      .deep_symbolize_keys
      .tap { |hash| keys_to_ignore.each { |k| hash.delete(k) } }
      .keys
  end

  it { is_expected.to be_success }

  it 'adapt unite legale to expected format' do
    expect(subject[:result].keys).to contain_exactly(*expected_keys)
  end
end
