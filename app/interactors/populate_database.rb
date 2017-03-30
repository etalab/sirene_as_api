class PopulateDatabase
  include Interactor::Organizer

  organize ImportLastMonthlyStock, SelectAndApplyPatches
end
