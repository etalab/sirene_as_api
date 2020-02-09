require 'rails_helper'

describe INSEE::ApiClient do
  subject { described_class.new(params).call }

  let(:params) do
    {
      daily_update: daily_update,
      cursor: '*',
      token: token
    }
  end

  let(:logger) { instance_spy(Logger) }
  let(:token) { INSEE::Request::RenewToken.call(logger: logger)[:token] }

  context 'with valid params for Etablissement', vcr: { cassette_name: 'insee/siret_small_update_OK' } do
    let(:daily_update) { create :daily_update_etablissement, from: from, to: to }
    let(:from) { Time.zone.local(2019, 11, 30) }
    let(:to) { Time.zone.local(2019, 12, 1) }

    it { is_expected.to be_a Net::HTTPOK }
  end

  describe 'UniteLegale' do
    let(:daily_update) { create :daily_update_unite_legale, from: from, to: to }
    let(:from) { Time.zone.local(2019, 12, 8) }
    let(:to) { Time.zone.local(2019, 12, 9) }

    context 'with valid params for UniteLegale', vcr: { cassette_name: 'insee/siren_small_update_OK' } do
      it { is_expected.to be_a Net::HTTPOK }
    end

    context 'with invalid filter name', vcr: { cassette_name: 'insee/siren_updates_wrong_filter' } do
      let(:from) { Time.zone.local(2020, 1, 1) } # from > to

      it { is_expected.to be_a Net::HTTPBadRequest }
    end

    context 'with update_type: full is updates on all perimeter', vcr: { cassette_name: 'insee/siren_full_update_OK' } do
      before do
        daily_update.update(update_type: 'full')
        stub_const('INSEE::ApiClient::MAX_ELEMENTS_PER_CALL', 20)
      end

      it { is_expected.to be_a Net::HTTPOK }

      it 'calls an URL without dateDernierTraitement' do
        expect(Net::HTTP::Get).to receive(:new)
          .with(an_object_having_attributes(query: 'nombre=20&curseur=*'))
          .and_call_original
        subject
      end
    end
  end
end
