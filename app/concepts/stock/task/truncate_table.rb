class Stock
  module Task
    class TruncateTable < Trailblazer::Operation
      step :truncate
      fail :log_transaction_failed
      pass :log_truncate_completed

      def truncate(ctx, table_name:, **)
        ActiveRecord::Base.transaction do
          execute_transaction(ctx, table_name)
        end
      end

      def log_truncate_completed(_, table_name:, logger:, **)
        logger.info "Truncate of #{table_name} completed"
      end

      def log_transaction_failed(_, error:, logger:, **)
        logger.error "Truncate failed: #{error.message}"
      end

      private

      def execute_transaction(ctx, table_name)
        ActiveRecord::Base.connection.execute sql(table_name)
      rescue ActiveRecord::ActiveRecordError
        ctx[:error] = $ERROR_INFO
        raise ActiveRecord::Rollback
      end

      def sql(table_name)
        "TRUNCATE TABLE #{table_name}"
      end
    end
  end
end
