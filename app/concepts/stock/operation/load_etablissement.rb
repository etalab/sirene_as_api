class Stock
  module Operation
    class LoadEtablissement < Trailblazer::Operation
      step :stock_model
      step Nested Task::FetchLatestRemoteStockEtablissement
      step Nested Task::Load

      def stock_model(ctx, **)
        ctx[:stock_model] = StockEtablissement
      end
    end
  end
end
