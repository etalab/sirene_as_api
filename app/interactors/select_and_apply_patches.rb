class SelectAndApplyPatches
  include Interactor::Organizer

  organize GetRelevantPatchesLink, ApplyPatch
end
