require 'rails_helper'

describe DailyUpdate::Task::Supersede do
  subject { described_class.call model: model, results: results, logger: logger }

  let(:logger) { instance_spy Logger }
  let(:results) { [existing_item, new_item] }

  def sanitize_in_hash(element)
    element
      .attributes
      .symbolize_keys
      .tap { |e| %i[id created_at updated_at].each { |key| e.delete(key) } }
  end

  describe 'UniteLegale' do
    before { create :unite_legale, siren: existing_siren }

    let(:model) { UniteLegale }
    let(:new_item) { sanitize_in_hash(build(:unite_legale)) }
    let(:existing_siren) { '123456789' }

    context 'with valid inputs' do
      let(:existing_item) do
        sanitize_in_hash(
          build(:unite_legale, siren: existing_siren, denomination: 'updated denomination')
        )
      end

      it { is_expected.to be_success }

      it 'persist a new unite legale' do
        expect { subject }.to change(model, :count).by(1)
      end

      it 'update one unite legale' do
        subject
        unite_legale = UniteLegale.find_by siren: existing_siren
        expect(unite_legale.denomination).to eq('updated denomination')
      end

      it 'logs 2 unites legales created/updated' do
        subject
        expect(logger).to have_received(:info)
          .with('UniteLegale: 1 created, 1 updated')
      end
    end

    context 'with invalid input' do
      let(:existing_item) do
        etab = sanitize_in_hash(
          build(:unite_legale, siren: existing_siren, denomination: 'updated denomination')
        )
        etab[:not_an_attribute] = 'dummy value'
        etab
      end

      it { is_expected.to be_success }

      it 'logs an error' do
        subject
        expect(logger).to have_received(:error)
          .with(/ActiveModel::UnknownAttributeError: unknown attribute 'not_an_attribute' for UniteLegale/)
      end

      it 'still import new data' do
        expect { subject }.to change(model, :count).by(1)
      end
    end
  end

  describe 'Etablissement' do
    before { create :etablissement, siret: existing_siret }

    let(:model) { Etablissement }
    let(:new_item) { sanitize_in_hash(build(:etablissement)) }
    let(:existing_siret) { '12345678900000' }
    let(:existing_item) do
      sanitize_in_hash(
        build(:etablissement, siret: existing_siret, enseigne_1: 'updated enseigne')
      )
    end

    it { is_expected.to be_success }

    it 'persist a new etablissement' do
      expect { subject }.to change(model, :count).by(1)
    end

    it 'update one etablissement' do
      subject
      etablissement = Etablissement.find_by siret: existing_siret
      expect(etablissement.enseigne_1).to eq('updated enseigne')
    end

    it 'logs 2 etablissements created/updated' do
      subject
      expect(logger).to have_received(:info)
        .with('Etablissement: 1 created, 1 updated')
    end
  end
end
