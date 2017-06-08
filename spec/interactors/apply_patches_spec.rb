require 'rails_helper'

describe ApplyPatches do
  context 'when there are 1 patch to apply' do
    # context = Interactor::Context.new
    # context.links = 'spec/fixtures/sample_patches/sirene_2017095_E_Q.zip'
    # let(:links) { ['spec/fixtures/sample_patches/sirene_2017095_E_Q.zip'] }
    # before do
    #   Interactor::Context.new.links = ['spec/fixtures/sample_patches/sirene_2017095_E_Q.zip']
    before do
      #allow(ApplyPatches).to receive(:call) do
      #  double("Interactor::Context", links: ['spec/fixtures/sample_patches/sirene_2017095_E_Q.zip'])
      #end
    end
      # context.sort(:sort) { ['spec/fixtures/sample_patches/sirene_2017095_E_Q.zip'] }
    it 'call ApplyPatch 1 times' do
      expect_any_instance_of(ApplyPatch).to receive(:call).once
      ApplyPatches.call(links: ['spec/fixtures/sample_patches/sirene_2017095_E_Q.zip'])
    end
  end
end
