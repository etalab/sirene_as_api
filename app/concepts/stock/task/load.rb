class Stock
  module Task
    class Load < Trailblazer::Operation
      step :remote_stock_importable?
      fail :log_not_importable
      step :persist_new_stock
      step :import
      pass :log_import_starts

      def remote_stock_importable?(_, remote_stock:, **)
        remote_stock.importable?
      end

      def persist_new_stock(_, remote_stock:, **)
        remote_stock.save
      end

      def import(_, remote_stock:, **)
        ImportStockJob.perform_later remote_stock.id
      end

      def log_not_importable(_, remote_stock:, logger:, **)
        current_stock = remote_stock.class.current
        logger.warn "Remote stock not importable (remote month: #{remote_stock.month}, current (#{current_stock.status}) month: #{current_stock.month})"
      end

      def log_import_starts(_, remote_stock:, logger:, **)
        logger.info "New stock found #{remote_stock.month}, will import..."
      end
    end
  end
end
