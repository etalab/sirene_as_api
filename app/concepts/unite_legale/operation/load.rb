class UniteLegale
  module Operation
    class Load < Trailblazer::Operation
      step :stock_model
      step Nested Task::FetchLatestRemoteStock
      step Nested Stock::Task::Load

      def stock_model(ctx, **)
        ctx[:stock_model] = StockUniteLegale
      end
    end
  end
end
