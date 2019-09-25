class Stock
  module Task
    class TruncateTable < Trailblazer::Operation
      step :truncate
      pass :log_truncate_completed

      def truncate(_ctx, table_name:, logger:, **)
        ActiveRecord::Base.connection.execute sql(table_name)
      rescue ActiveRecord::ActiveRecordError
        logger.error "Truncate failed: #{$ERROR_INFO.message}"
        false
      end

      def log_truncate_completed(_, table_name:, logger:, **)
        logger.info "Truncate of #{table_name} completed"
      end

      private

      def sql(table_name)
        "TRUNCATE TABLE #{table_name}"
      end
    end
  end
end
