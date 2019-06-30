require 'rails_helper'

describe ApplyPatches do
  include_context 'mute interactors'

  context 'when there are 1 patch to apply' do
    it 'call ApplyPatch 1 times' do
      expect_any_instance_of(ApplyPatch).to receive(:call).once
      ApplyPatches.call(links: ['spec/fixtures/sample_patches/geo-sirene_2017024_E_Q.csv.gz'])
    end
  end
end
