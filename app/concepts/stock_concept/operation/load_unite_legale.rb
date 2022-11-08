class StockConcept
  module Operation
    class LoadUniteLegale < Trailblazer::Operation
      step :stock_model
      step Subprocess Task::FetchLatestRemoteStockUniteLegale
      step Subprocess Task::Load

      def stock_model(ctx, **)
        ctx[:stock_model] = StockUniteLegale
      end
    end
  end
end
