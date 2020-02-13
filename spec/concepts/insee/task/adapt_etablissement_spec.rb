require 'rails_helper'

describe INSEE::Task::AdaptEtablissement do
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
      %i[siren nic siret statut_diffusion date_creation tranche_effectifs annee_effectifs activite_principale_registre_metiers date_dernier_traitement etablissement_siege nombre_periodes complement_adresse numero_voie indice_repetition type_voie libelle_voie code_postal libelle_commune libelle_commune_etranger distribution_speciale code_commune code_cedex libelle_cedex code_pays_etranger libelle_pays_etranger complement_adresse_2 numero_voie_2 indice_repetition_2 type_voie_2 libelle_voie_2 code_postal_2 libelle_commune_2 libelle_commune_etranger_2 distribution_speciale_2 code_commune_2 code_cedex_2 libelle_cedex_2 code_pays_etranger_2 libelle_pays_etranger_2 date_debut etat_administratif enseigne_1 enseigne_2 enseigne_3 denomination_usuelle activite_principale nomenclature_activite_principale caractere_employeur]
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
