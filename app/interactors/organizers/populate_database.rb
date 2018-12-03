class PopulateDatabase
  include Interactor::Organizer

  # Deactivating SelectAndApplyPatches until we get v3 daily updates
  # organize ImportLastMonthlyStock, SaveLastMonthlyStockName, SelectAndApplyPatches, PostUpdateTasks
  organize ImportLastMonthlyStock, SaveLastMonthlyStockName, PostUpdateTasks
end
