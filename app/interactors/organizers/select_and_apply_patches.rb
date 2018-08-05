class SelectAndApplyPatches
  include Interactor::Organizer

  organize GetRelevantPatchesLinks, ApplyPatches, SolrReindex, SolrBuildDictionary
end
