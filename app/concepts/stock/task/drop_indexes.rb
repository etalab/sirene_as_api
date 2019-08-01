class Stock
  module Task
    class DropIndexes < Trailblazer::Operation
      include Stock::Helper::DatabaseIndexes

      step :drop_indexes
      step :log_indexes_dropped

      def drop_indexes(_, table_name:, **)
        each_index_configuration do |index_table_name, columns, options|
          next if index_table_name.to_s != table_name
          next unless ActiveRecord::Base.connection.index_exists?(index_table_name, columns, options)
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
