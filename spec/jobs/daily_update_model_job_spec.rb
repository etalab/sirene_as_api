require 'rails_helper'

describe DailyUpdateModelJob, :trb do
  subject { described_class.perform_now model_name }

  before do
    allow(DailyUpdate::Operation::Update)
      .to receive(:call)
      .and_return(trb_result_success)
  end

  describe 'with UniteLegale' do
    let(:model_name) { 'unite_legale' }

    it 'calls the update operation' do
      expect(DailyUpdate::Operation::Update)
        .to receive(:call)
        .with(model: UniteLegale, logger: an_instance_of(Logger))
      subject
    end

    it 'uses logger of the model' do
      expect(Logger).to receive(:new)
        .with(/daily_update_unite_legale.log/)
        .and_call_original
      subject
    end
  end

  describe 'with Etablissement' do
    let(:model_name) { 'etablissement' }

    it 'call the update operation' do
      expect(DailyUpdate::Operation::Update)
        .to receive(:call)
        .with(model: Etablissement, logger: an_instance_of(Logger))
      subject
    end

    it 'uses logger of the model' do
      expect(Logger).to receive(:new)
        .with(/daily_update_etablissement.log/)
        .and_call_original
      subject
    end
  end

  describe 'operation failure' do
    let(:model_name) { 'unite_legale' }
    it 'rollback the operation' do
      allow(DailyUpdate::Operation::Update)
        .to receive(:call)
        .and_wrap_original do |_original_method, *_args|
          create :unite_legale, siren: 'GHOST'
          trb_result_failure
        end

      subject
      expect(UniteLegale.where(siren: 'GHOST')).to be_empty
    end
  end
end
