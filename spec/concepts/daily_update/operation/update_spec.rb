require 'rails_helper'

describe DailyUpdate::Operation::Update, :trb do
  subject { described_class.call daily_update: daily_update, logger: logger }

  let(:daily_update) { create :daily_update_unite_legale, from: from, to: to }
  let(:logger) { instance_spy Logger }
  let(:from) { Time.zone.local(2019, 12, 1) }
  let(:to) { Time.zone.local(2019, 12, 1, 20, 0, 0) }

  context 'when updating UniteLegale', vcr: { cassette_name: 'insee/siren_update_1st_december' } do
    it { is_expected.to be_success }

    it 'logs the period to import' do
      subject
      expect(logger).to have_received(:info)
        .with(/Importing from 2019-12-01 00:00:00.+ to 2019-12-01 20:00:00.+/)
    end

    it 'logs database updated' do
      subject
      expect(logger).to have_received(:info)
        .with('UniteLegale updated until 2019-12-01 20:00:00 +0100')
    end

    it 'fetch updates' do
      expect_to_call_nested_operation(INSEE::Operation::FetchUpdates)
      subject
    end
  end
end
