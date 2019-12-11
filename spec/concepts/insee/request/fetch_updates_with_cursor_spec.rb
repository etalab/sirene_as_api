require 'rails_helper'

describe INSEE::Request::FetchUpdatesWithCursor do
  subject { described_class.call params }

  let(:params) do
    {
      model: model,
      from: from,
      to: to,
      cursor: cursor,
      logger: logger
    }
  end

  let(:cursor) { '*' }
  let(:logger) { instance_spy Logger }

  context 'with valid params for Etablissement', vcr: { cassette_name: 'insee/siret_small_update_OK' } do
    let(:model) { Etablissement }
    let(:from) { Date.new(2019, 11, 30) }
    let(:to) { Date.new(2019, 12, 1) }

    it { is_expected.to be_success }

    its([:body]) { is_expected.to be_a(Hash) }

    it 'logs http get success' do
      subject
      expect(logger).to have_received(:info)
        .with('49 etablissements retrieved, new cursor: AoEuODc5MTc4NTQ5MDAwMTc=')
    end
  end

  describe 'UniteLegale' do
    let(:model) { UniteLegale }
    let(:from) { Date.new(2019, 12, 8) }
    let(:to) { Date.new(2019, 12, 9) }

    context 'with valid params for UniteLegale', vcr: { cassette_name: 'insee/siren_small_update_OK' } do
      it { is_expected.to be_success }

      its([:body]) { is_expected.to be_a(Hash) }

      it 'logs http get success' do
        subject
        expect(logger).to have_received(:info)
          .with('60 unitesLegales retrieved, new cursor: AoEpODc5MDc1NjM4')
      end
    end

    context 'with invalid filter name', vcr: { cassette_name: 'insee/siren_updates_wrong_filter' } do
      let(:from) { Date.new(2020, 1, 1) } # from > to

      it { is_expected.to be_failure }

      its([:body]) { is_expected.to be_nil }

      it 'logs http failed' do
        subject
        expect(logger).to have_received(:error)
          .with(/HTTP request failed \(code: 400\)\: .+/)
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
