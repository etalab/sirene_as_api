class Etablissement
  module Operation
    class Load < Trailblazer::Operation
      step :stock_model
      step Nested Task::FetchLatestRemoteStock
      step Nested Stock::Task::Load

      def stock_model(ctx, **)
        ctx[:stock_model] = StockEtablissement
      end
    end
  end
end
