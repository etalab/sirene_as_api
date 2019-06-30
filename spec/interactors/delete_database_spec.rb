require 'rails_helper'

describe DeleteDatabase do
  include_context 'mute interactors'

  context 'when called' do
    it 'delete database' do
      expect(EtablissementV2).to receive(:delete_all).once
      described_class.call
    end
  end
end
