class Stock
  module Task
    class DropIndexes < Trailblazer::Operation
      include Stock::Helper::DatabaseIndexes

      step :drop_indexes
      step :log_indexes_dropped

      def drop_indexes(ctx, **)
        each_index_configuration do |table_name, columns, options|
          next unless ActiveRecord::Base.connection.index_exists?(table_name, columns, options)

          ActiveRecord::Base
            .connection
            .remove_index table_name, column: columns
        end
      end

      def log_indexes_dropped(ctx, logger:, **)
        logger.info 'Indexes dropped'
      end
    end
  end
end
