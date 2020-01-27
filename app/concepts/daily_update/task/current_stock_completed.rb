class DailyUpdate
  module Task
    class CurrentStockCompleted < Trailblazer::Operation
      step :stock_unite_legale_completed?
      step :stock_etablissement_completed?
      fail :log_stock_not_completed

      def stock_unite_legale_completed?(ctx, **)
        imported = StockUniteLegale.current&.imported?
        ctx[:errored_stock] = StockUniteLegale unless imported
        imported
      end

      def stock_etablissement_completed?(ctx, **)
        imported = StockEtablissement.current&.imported?
        ctx[:errored_stock] = StockEtablissement unless imported
        imported
      end

      def log_stock_not_completed(_, errored_stock:, logger:, **)
        logger.error "Stock #{errored_stock} not completed (#{errored_stock.current&.status || 'NOT FOUND'}), skipping daily update"
      end
    end
  end
end
