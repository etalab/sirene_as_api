class Stock
  module Task
    class TruncateTable < Trailblazer::Operation
      step :truncate

      def truncate(ctx, table_name:, logger:, **)
        ActiveRecord::Base.connection.execute sql(table_name)
      rescue ActiveRecord::ActiveRecordError
        logger.error "Truncate failed: #{$ERROR_INFO.message}"
        false
      end

      private

      def sql(table_name)
        "TRUNCATE TABLE #{table_name}"
      end
    end
  end
end
