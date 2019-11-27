class Stock
  module Operation
    class PostImport < Trailblazer::Operation
      step :stock_unite_legale_imported?
      step :stock_etablissement_imported?
      fail :log_stock_not_imported, Output(:success) => 'End.success'
      step Nested Task::CreateAssociations
      step Nested Task::DropIndexes
      step Nested Task::SwapTableNames
      step Nested Task::CreateIndexes

      def stock_unite_legale_imported?(_ctx, **)
        StockUniteLegale.current&.imported?
      end

      def stock_etablissement_imported?(_ctx, **)
        StockEtablissement.current&.imported?
      end

      def log_stock_not_imported(_ctx, logger:, **)
        logger.info 'Other import not finished'
      end
    end
  end
end
