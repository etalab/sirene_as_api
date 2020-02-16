require 'rails_helper'

describe INSEE::Operation::FetchUpdates, :trb do
  subject { described_class.call daily_update: daily_update, logger: logger }

  let(:logger) { instance_spy Logger }

  before do
    stub_const('INSEE::ApiClient::MAX_ELEMENTS_PER_CALL', 20)
  end

  describe 'with Etablissement', vcr: { cassette_name: 'insee/siret_small_update_OK' } do
    let(:daily_update) { create :daily_update_etablissement, from: from, to: to }
    let(:from) { Time.zone.local(2019, 11, 30) }
    let(:to) { Time.zone.local(2019, 12, 1) }

    it { is_expected.to be_success }

    it 'calls request 4 times' do
      expect_to_call_nested_operation(INSEE::Request::FetchUpdatesWithCursor)
        .exactly(4).times
      subject
    end

    it 'calls import 4 times' do
      expect_to_call_nested_operation(INSEE::Operation::ImportRawData)
        .exactly(4).times
      subject
    end

    it 'logs how many entities have been fetched' do
      subject
      expect(logger).to have_received(:info)
        .with('Total: 49 Etablissement fetched')
    end
  end

  describe 'with UniteLegale', vcr: { cassette_name: 'insee/siren_small_update_OK' } do
    let(:daily_update) { create :daily_update_unite_legale, from: from, to: to }
    let(:from) { Time.zone.local(2019, 12, 8) }
    let(:to) { Time.zone.local(2019, 12, 9) }

    it { is_expected.to be_success }

    it 'calls request 4 times' do
      expect_to_call_nested_operation(INSEE::Request::FetchUpdatesWithCursor)
        .exactly(4).times
      subject
    end

    it 'calls import 4 times' do
      expect_to_call_nested_operation(INSEE::Operation::ImportRawData)
        .exactly(4).times
      subject
    end

    it 'logs how many entities have been fetched' do
      subject
      expect(logger).to have_received(:info)
        .with('Total: 60 UniteLegale fetched')
    end
  end

  describe 'with unite legale non diffusables', vcr: { cassette_name: 'insee/siren_non_diffusable_small_update_OK' } do
    let(:daily_update) { create :daily_update_unite_legale_non_diffusable, from: from, to: to }
    let(:from) { Time.zone.local(2019, 12, 8) }
    let(:to) { Time.zone.local(2019, 12, 9) }

    it { is_expected.to be_success }

    it 'calls request 2 times' do
      expect_to_call_nested_operation(INSEE::Request::FetchUpdatesWithCursor)
        .exactly(2).times
      subject
    end

    it 'calls import 2 times' do
      expect_to_call_nested_operation(INSEE::Operation::ImportRawData)
        .exactly(2).times
      subject
    end

    it 'logs how many entities have been fetched' do
      subject
      expect(logger).to have_received(:info)
        .with('Total: 12 UniteLegale fetched')
    end
  end

  describe 'with etablissement non diffusables', vcr: { cassette_name: 'insee/siret_non_diffusable_small_update_OK' } do
    let(:daily_update) { create :daily_update_etablissement_non_diffusable, from: from, to: to }
    let(:from) { Time.zone.local(2019, 12, 8) }
    let(:to) { Time.zone.local(2019, 12, 9) }

    it { is_expected.to be_success }

    it 'calls request 8 times' do
      expect_to_call_nested_operation(INSEE::Request::FetchUpdatesWithCursor)
        .exactly(8).times
      subject
    end

    it 'calls import 8 times' do
      expect_to_call_nested_operation(INSEE::Operation::ImportRawData)
        .exactly(8).times
      subject
    end

    it 'logs how many entities have been fetched' do
      subject
      expect(logger).to have_received(:info)
        .with('Total: 131 Etablissement fetched')
    end
  end

  context 'when an API call fails' do
    before do
      allow(INSEE::Request::FetchUpdatesWithCursor)
        .to receive(:call)
        .and_return(trb_result_failure)
    end

    let(:daily_update) { create :daily_update_unite_legale, from: from, to: to }
    let(:from) { Time.zone.local(2019, 12, 8) }
    let(:to) { Time.zone.local(2019, 12, 9) }

    it { is_expected.to be_failure }

    it 'logs an error' do
      subject
      expect(logger).to have_received(:error)
        .with('Fetching new UniteLegale failed')
    end

    it 'do not call import' do
      expect_not_to_call_nested_operation(INSEE::Operation::ImportRawData)
      subject
    end
  end
end
