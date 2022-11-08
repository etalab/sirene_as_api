class StockConcept
  module Operation
    class LoadEtablissement < Trailblazer::Operation
      step :stock_model
      step Subprocess Task::FetchLatestRemoteStockEtablissement
      step Subprocess Task::Load

      def stock_model(ctx, **)
        ctx[:stock_model] = StockEtablissement
      end
    end
  end
end
