require 'rails_helper'

describe DailyUpdate::Task::AdaptEtablissement do
  subject { described_class.call result: etablissement_insee }

  let(:etablissement_insee) do
    JSON.parse(
      File.read(fixture_path),
      symbolize_names: true
    )
  end

  describe 'etablissement diffusable' do
    let(:fixture_path) { 'spec/fixtures/samples_insee/etablissement.json' }
    let(:keys_to_ignore) { rails_keys + geo_keys }
    let(:rails_keys) { %i[id unite_purgee created_at updated_at unite_legale_id] }
    let(:geo_keys) { %i[longitude latitude geo_score geo_type geo_adresse geo_id geo_ligne geo_l4 geo_l5] }

    let(:expected_keys) do
      Etablissement
        .new
        .attributes
        .deep_symbolize_keys
        .tap { |hash| keys_to_ignore.each { |k| hash.delete(k) } }
        .keys
    end

    it { is_expected.to be_success }

    it 'adapt etablissement to expected format' do
      expect(subject[:result].keys).to contain_exactly(*expected_keys)
    end
  end

  describe 'etablissement non diffusable' do
    let(:fixture_path) { 'spec/fixtures/samples_insee/etablissement_non_diffusable.json' }
    let(:expected_keys) { %i[siren nic siret statut_diffusion date_dernier_traitement] }

    it { is_expected.to be_success }

    it 'adapt unite legale to expected format' do
      expect(subject[:result].keys).to contain_exactly(*expected_keys)
    end
  end
end
