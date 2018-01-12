class PopulateDatabase
  include Interactor::Organizer

  organize ImportLastMonthlyStock, SaveLastMonthlyStockName, SelectAndApplyPatches
end
