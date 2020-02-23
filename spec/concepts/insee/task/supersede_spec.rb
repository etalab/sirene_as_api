require 'rails_helper'

describe INSEE::Task::Supersede do
  subject { described_class.call model: model, business_key: business_key, data: data, logger: logger }

  let(:logger) { instance_spy Logger }

  describe 'UniteLegale' do
    let(:model) { UniteLegale }
    let(:business_key) { :siren }

    describe 'new unite legale created' do
      let(:new_siren) { '123456789' }
      let(:data) { { siren: new_siren, denomination: 'dummy denomination', statut_diffusion: 'O' } }

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
      let(:data) { { siren: existing_siren, denomination: 'updated denomination' } }

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
      let(:data) { { siren: '000000000', not_an_attribute: 'dummy value' } }

      it { is_expected.to be_failure }

      it 'logs an error' do
        subject
        expect(logger).to have_received(:error)
          .with(/ActiveModel::UnknownAttributeError: unknown attribute 'not_an_attribute' for UniteLegale/)
      end
    end

    context 'when existing unite legale becomes non-diffusable' do
      before { create :unite_legale, siren: existing_siren }

      let(:existing_siren) { '123456789' }
      let(:data) { { siren: existing_siren, statut_diffusion: 'N' } }

      it { is_expected.to be_success }

      it 'does not persist a new unite legale' do
        expect { subject }.not_to change(model, :count)
      end

      it 'updates one unite legale' do
        subject
        unite_legale = UniteLegale.find_by siren: existing_siren
        expect(unite_legale.statut_diffusion).to eq('N')
      end

      it 'nullify fields' do
        unite_legale = UniteLegale.find_by siren: existing_siren
        expect(unite_legale.denomination).not_to be_nil
        subject
        unite_legale.reload
        expect(unite_legale.denomination).to be_nil
      end
    end

    context 'when new unite legale is non-diffusable' do
      let(:new_siren) { '123456789' }
      let(:data) { { siren: new_siren, denomination: 'dummy denomination', statut_diffusion: 'N' } }

      it { is_expected.to be_success }

      it 'persists a new unite legale' do
        expect { subject }.to change(model, :count).by(1)
      end

      it 'creates the right unite legale' do
        subject
        unite_legale = UniteLegale.find_by siren: new_siren
        expect(unite_legale).to be_persisted
      end

      it 'nullify fields' do
        subject
        unite_legale = UniteLegale.find_by siren: new_siren
        expect(unite_legale.denomination).to be_nil
      end
    end
  end

  describe 'Etablissement' do
    let(:model) { Etablissement }
    let(:business_key) { :siret }
    let(:data) { { siret: '12345678900000' } }

    it { is_expected.to be_success }

    it 'persist a new etablissement' do
      expect { subject }.to change(model, :count).by(1)
    end
  end
end
