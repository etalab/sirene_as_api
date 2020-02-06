require 'rails_helper'

describe DailyUpdate::Task::CreateAssociations do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }
  let(:siren) { '123456789' }
  let!(:unite_legale) { create :unite_legale, siren: siren }

  before do
    create_list :etablissement, 2, siren: siren
  end

  describe 'SQL operation success' do
    it { is_expected.to be_success }

    it 'logs association starts' do
      subject
      expect(logger).to have_received(:info).with('Models associations starts')
    end

    it 'logs associations done' do
      subject
      expect(logger).to have_received(:info).with('Models associations completed')
    end

    it 'creates database association' do
      subject
      unite_legale.reload
      expect(unite_legale.etablissements).to have(2).items
    end
  end

  context 'when association failed' do
    before do
      allow_any_instance_of(described_class)
        .to receive(:sql)
        .and_return 'an invalid SQL statement'
    end

    it { is_expected.to be_failure }

    it 'logs import starts' do
      subject
      expect(logger).to have_received(:info).with('Models associations starts')
    end

    it 'logs an error' do
      subject
      expect(logger).to have_received(:error).with(/Association failed:/)
    end

    it 'does not create association' do
      subject
      expect(unite_legale.etablissements).to be_empty
    end
  end
end
