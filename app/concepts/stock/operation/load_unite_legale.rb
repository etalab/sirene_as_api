class Stock
  module Operation
    class LoadUniteLegale < Trailblazer::Operation
      step :stock_model
      step Nested Task::FetchLatestRemoteStockUniteLegale
      step Nested Task::Load

      def stock_model(ctx, **)
        ctx[:stock_model] = StockUniteLegale
      end
    end
  end
end
