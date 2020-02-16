require 'rails_helper'

describe INSEE::Task::AdaptUniteLegale do
  subject { described_class.call result: unite_legale_insee }

  let(:unite_legale_insee) do
    JSON.parse(
      File.read(fixture_path),
      symbolize_names: true
    )
  end

  describe 'unite legale diffusable' do
    let(:fixture_path) { 'spec/fixtures/samples_insee/unite_legale.json' }
    let(:keys_to_ignore) { %i[id unite_purgee created_at updated_at] }
    let(:expected_keys) do
      %i[siren statut_diffusion date_creation sigle sexe prenom_1 prenom_2 prenom_3 prenom_4 prenom_usuel pseudonyme identifiant_association tranche_effectifs annee_effectifs date_dernier_traitement nombre_periodes categorie_entreprise annee_categorie_entreprise date_fin date_debut etat_administratif nom nom_usage denomination denomination_usuelle_1 denomination_usuelle_2 denomination_usuelle_3 categorie_juridique activite_principale nomenclature_activite_principale nic_siege economie_sociale_solidaire caractere_employeur]
    end

    it { is_expected.to be_success }

    it 'adapt unite legale to expected format' do
      expect(subject[:result].keys).to contain_exactly(*expected_keys)
    end
  end

  describe 'unite legale non diffusable' do
    let(:fixture_path) { 'spec/fixtures/samples_insee/unite_legale_non_diffusable.json' }
    let(:expected_keys) { %i[siren statut_diffusion date_dernier_traitement] }

    it { is_expected.to be_success }

    it 'adapt unite legale to expected format' do
      expect(subject[:result].keys).to contain_exactly(*expected_keys)
    end
  end
end
