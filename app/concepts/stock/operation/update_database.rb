class Stock
  module Operation
    class UpdateDatabase < Trailblazer::Operation
      step Nested CheckStockAvailability
      step Nested LoadUniteLegale
      step Nested LoadEtablissement
    end
  end
end
