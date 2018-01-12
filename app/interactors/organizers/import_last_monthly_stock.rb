class ImportLastMonthlyStock
  include Interactor::Organizer

  organize GetLastMonthlyStockLink, DownloadFile, UnzipFile, ImportMonthlyStockCsv
end
