class Stock
  module Task
    class Load < Trailblazer::Operation
      step :stock_exist?, Output(:failure) => Track(:empty_database)
      step :newer?
      fail :log_database_up_to_date
      pass :log_database_empty, magnetic_to: [:empty_database]
      step :persist_new_stock
      step :import
      pass :log_import_starts

      def stock_exist?(ctx, **)
        !ctx[:current_stock].nil?
      end

      def newer?(_, remote_stock:, current_stock:, **)
        remote_stock.newer? current_stock
      end

      def persist_new_stock(_, remote_stock:, **)
        remote_stock.save
      end

      def import(_, remote_stock:, **)
        ImportStockJob.perform_later remote_stock.id
      end

      def log_database_empty(_, logger:, **)
        logger.info 'Database empty'
      end

      def log_database_up_to_date(_, remote_stock:, current_stock:, logger:, **)
        logger.warn "Database up to date (found #{remote_stock.month}, current #{current_stock.month})"
      end

      def log_import_starts(_, remote_stock:, logger:, **)
        logger.info "New stock found #{remote_stock.month}, will import..."
      end
    end
  end
end
