class SelectAndApplyPatches
  include Interactor::Organizer

  organize GetRelevantPatchesLinks, BeforeApplyingUpdateIndexJob, ApplyPatches, AfterApplyingUpdateIndexJob
end
