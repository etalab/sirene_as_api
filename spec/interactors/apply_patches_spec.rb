require 'rails_helper'

describe ApplyPatches do
  context 'when there are 1 patch to apply' do
    it 'call ApplyPatch 1 times' do
      expect_any_instance_of(ApplyPatch).to receive(:call).once
      ApplyPatches.call(links: ['spec/fixtures/sample_patches/sirene_2017095_E_Q.zip'])
    end
  end
end
