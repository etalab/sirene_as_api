require 'rails_helper'
require 'ruby-progressbar'

#this test will check the last update, then apply one patch in the ../fixtures/sample_patches folder,
# then rollback and check if the last update is the same.
describe RollbackPatch do
  context 'when a patch must be cancelled' do
    it 'rollback correctly the last patch'
      # Etablissement = double("Etablissement", :latest_mise_a_jour => "2017-03-27T10:55:43", :find_or_initialize_by => ':siret=>"02407644000023"')
      # update_before_patch = Etablissement.latest_mise_a_jour
      # ApplyPatch.new(link: test_link).call
      # RollbackPatch.new(link: test_link).call
      # update_after_rollback = Etablissement.latest_mise_a_jour
      # expect(update_before_patch).to eq(update_after_rollback)
  end

  def test_link
    "http://files.data.gouv.fr/sirene/sirene_2017095_E_Q.zip"
  end
end
