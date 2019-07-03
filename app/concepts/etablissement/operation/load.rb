class Etablissement
  module Operation
    class Load < Trailblazer::Operation
      step :stock_model
      step :table_name
      step Nested Stock::Task::TruncateTable
      step Nested Stock::Task::PreLoadChecks
      step Nested Task::FetchLatestRemoteStock
      step Nested Stock::Task::Load

      def stock_model(ctx,  **)
        ctx[:stock_model] = StockEtablissement
      end

      def table_name(ctx, **)
        ctx[:table_name] = 'etablissements'
      end
    end
  end
end
