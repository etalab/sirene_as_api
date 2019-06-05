class Stock
  module Task
    class PreLoadChecks < Trailblazer::Operation
      step :fetch_current_stock
        fail :log_database_empty, Output(:success) => 'End.success'
      step :check_current_stock_status

      def fetch_current_stock(ctx, **)
        ctx[:current_stock] = Stock.current
      end

      def check_current_stock_status(ctx, current_stock:, logger:, **)
        case current_stock.status
        when 'LOADING', 'PENDING'
          logger.error "Current stock is #{current_stock.status}"
          ctx[:current_stock] = nil
          false
        when 'ERROR'
          logger.info 'Previous stock in ERROR, will re-import...'
          current_stock.delete
          ctx[:current_stock] = nil
          true
        when 'COMPLETED'
          true
        end
      end

      def log_database_empty(ctx, logger:, **)
        logger.info 'Database empty, will import...'
      end
    end
  end
end
