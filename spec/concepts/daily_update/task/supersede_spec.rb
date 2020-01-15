require 'rails_helper'

describe DailyUpdate::Task::Supersede do
  subject { described_class.call model: model, data: data, logger: logger }

  let(:logger) { instance_spy Logger }

  def generate_hash_like_insee(element)
    element
      .attributes
      .symbolize_keys
      .tap { |e| %i[id created_at updated_at].each { |key| e.delete(key) } }
  end

  describe 'UniteLegale' do
    let(:model) { UniteLegale }

    describe 'new unite legale created' do
      let(:new_siren) { '123456789' }
      let(:data) do
        generate_hash_like_insee(
          build(:unite_legale, siren: new_siren, denomination: 'dummy denomination')
        )
      end

      it { is_expected.to be_success }

      it 'persists a new unite legale' do
        expect { subject }.to change(model, :count).by(1)
      end

      it 'creates the right unite legale' do
        subject
        unite_legale = UniteLegale.find_by siren: new_siren
        expect(unite_legale.denomination).to eq('dummy denomination')
      end
    end

    describe 'existing unite legale updated' do
      before { create :unite_legale, siren: existing_siren }

      let(:existing_siren) { '123456789' }
      let(:data) do
        generate_hash_like_insee(
          build(:unite_legale, siren: existing_siren, denomination: 'updated denomination')
        )
      end

      it { is_expected.to be_success }

      it 'does not persist a new unite legale' do
        expect { subject }.not_to change(model, :count)
      end

      it 'updates one unite legale' do
        subject
        unite_legale = UniteLegale.find_by siren: existing_siren
        expect(unite_legale.denomination).to eq('updated denomination')
      end
    end

    context 'when primary key not found' do
      let(:data) { { sirenn: 'misspell primary key' } }

      it { is_expected.to be_failure }

      it 'logs missing primary key' do
        subject
        expect(logger).to have_received(:error)
          .with("Supersede failed, primary key (siren) not found in #{data}")
      end
    end

    context 'when the input is invalid' do
      let(:data) do
        etab = generate_hash_like_insee(
          build(:unite_legale, denomination: 'updated denomination')
        )
        etab[:not_an_attribute] = 'dummy value'
        etab
      end

      it { is_expected.to be_failure }

      it 'logs an error' do
        subject
        expect(logger).to have_received(:error)
          .with(/ActiveModel::UnknownAttributeError: unknown attribute 'not_an_attribute' for UniteLegale/)
      end
    end
  end

  describe 'Etablissement' do
    let(:model) { Etablissement }
    let(:data) { generate_hash_like_insee(build(:etablissement)) }

    it { is_expected.to be_success }

    it 'persist a new etablissement' do
      expect { subject }.to change(model, :count).by(1)
    end
  end
end
