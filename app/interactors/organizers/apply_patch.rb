class ApplyPatch
  include Interactor::Organizer

  organize DownloadFile, UnzipFile, ApplyFrequentUpdateCsvPatch
end
