class StockConcept
  module Operation
    class UpdateDatabase < Trailblazer::Operation
      step Subprocess CheckStockAvailability
      step Subprocess LoadUniteLegale
      step Subprocess LoadEtablissement
    end
  end
end
