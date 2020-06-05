require 'rails_helper'

describe INSEE::Request::FetchUpdatesWithCursor do
  subject { described_class.call params }

  let(:params) do
    {
      daily_update: daily_update,
      cursor: cursor,
      logger: logger
    }
  end

  let(:cursor) { '*' }
  let(:logger) { instance_spy Logger }

  context 'with valid params for Etablissement', vcr: { cassette_name: 'insee/siret_small_update_OK' } do
    let(:daily_update) { create :daily_update_etablissement, from: from, to: to }
    let(:from) { Time.zone.local(2019, 11, 30) }
    let(:to) { Time.zone.local(2019, 12, 1) }

    it { is_expected.to be_success }

    its([:body]) { is_expected.to be_a(Hash) }

    it 'logs http get success' do
      subject
      expect(logger).to have_received(:info)
        .with('49 Etablissement retrieved (total: 49), new cursor: AoEuODc5MTc4NTQ5MDAwMTc=')
    end
  end

  describe 'UniteLegale' do
    let(:daily_update) { create :daily_update_unite_legale, from: from, to: to }
    let(:from) { Time.zone.local(2019, 12, 8) }
    let(:to) { Time.zone.local(2019, 12, 9) }

    context 'with valid params for UniteLegale', vcr: { cassette_name: 'insee/siren_small_update_OK' } do
      it { is_expected.to be_success }

      its([:body]) { is_expected.to be_a(Hash) }

      it 'logs http get success' do
        subject
        expect(logger).to have_received(:info)
          .with('60 UniteLegale retrieved (total: 60), new cursor: AoEpODc5MDc1NjM4')
      end
    end

    context 'with invalid filter name', vcr: { cassette_name: 'insee/siren_updates_wrong_filter' } do
      let(:from) { Time.zone.local(2020, 1, 1) } # from > to

      it { is_expected.to be_failure }

      its([:body]) { is_expected.to be_nil }

      it 'logs http failed' do
        subject
        expect(logger).to have_received(:error)
          .with(/HTTP request failed \(code: 400\): .+/)
      end
    end

    context 'with update_type: full is updates on all perimeter' do
      before do
        stub_const('INSEE::ApiClient::MAX_ELEMENTS_PER_CALL', 20)
      end

      let(:daily_update) { create :daily_update_unite_legale_non_diffusable, update_type: 'full' }

      context 'with valid params for UniteLegale', vcr: { cassette_name: 'insee/siren_non_diffusable_update_all_OK' } do
        it { is_expected.to be_success }

        its([:body]) { is_expected.to be_a(Hash) }

        it 'logs http get success' do
          subject
          expect(logger).to have_received(:info)
            .with('20 UniteLegale retrieved (total: 703776), new cursor: AoIpMDU3MTAyMTA1KTA1NzEwMjEwNQ==')
        end
      end
    end

    context 'when body is not JSON', vcr: { cassette_name: 'insee/siren_small_update_OK' } do
      before do
        allow_any_instance_of(described_class)
          .to receive(:read_body)
          .and_return nil
      end

      it { is_expected.to be_failure }

      its([:body]) { is_expected.to be_nil }

      it 'logs parsing failed' do
        subject
        expect(logger).to have_received(:error)
          .with(/Body is not a valid JSON \(.+\)/)
      end
    end
  end
end
