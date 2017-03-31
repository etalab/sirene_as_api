class SelectAndApplyPatches
  include Interactor::Organizer

  organize GetRelevantPatchesLinks, ApplyPatch
end
