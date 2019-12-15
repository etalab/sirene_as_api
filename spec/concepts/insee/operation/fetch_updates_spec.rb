require 'rails_helper'

describe INSEE::Operation::FetchUpdates, :trb do
  subject { described_class.call params }

  let(:logger) { instance_spy Logger }
  let(:params) do
    {
      model: model,
      from: from,
      to: to,
      logger: logger
    }
  end

  before do
    stub_const('INSEE::Request::FetchUpdatesWithCursor::MAX_ELEMENTS_PER_CALL', 20)
  end

  describe 'with Etablissement', vcr: { cassette_name: 'insee/siret_small_update_OK' } do
    let(:model) { Etablissement }
    let(:from) { Date.new(2019, 11, 30) }
    let(:to) { Date.new(2019, 12, 1) }

    it { is_expected.to be_success }

    its([:api_results]) { is_expected.to have_attributes(count: 49) }

    it 'calls request 4 times' do
      expect_to_call_nested_operation(INSEE::Request::FetchUpdatesWithCursor)
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
    let(:model) { UniteLegale }
    let(:from) { Date.new(2019, 12, 8) }
    let(:to) { Date.new(2019, 12, 9) }

    it { is_expected.to be_success }

    its([:api_results]) { is_expected.to have_attributes(count: 60) }

    it 'calls request 4 times' do
      expect_to_call_nested_operation(INSEE::Request::FetchUpdatesWithCursor)
        .exactly(4).times
      subject
    end

    it 'logs how many entities have been fetched' do
      subject
      expect(logger).to have_received(:info)
        .with('Total: 60 UniteLegale fetched')
    end
  end

  context 'when an API call fails' do
    before do
      allow(INSEE::Request::FetchUpdatesWithCursor)
        .to receive(:call)
        .and_return(trb_result_failure)
    end

    let(:model) { UniteLegale }
    let(:from) { Date.new(2019, 12, 8) }
    let(:to) { Date.new(2019, 12, 9) }

    it { is_expected.to be_failure }

    it 'logs an error' do
      subject
      expect(logger).to have_received(:error)
        .with('Fetching new UniteLegale failed')
    end

    its([:api_results]) { are_expected.to be_empty }
  end
end
