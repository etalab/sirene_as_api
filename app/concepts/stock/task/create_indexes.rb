class Stock
  module Task
    class CreateIndexes < Trailblazer::Operation
      include Stock::Helper::DatabaseIndexes

      pass :log_indexes_creation_starts
      step :create_indexes
      pass :log_indexes_created

      def create_indexes(_, logger:, **)
        each_index_configuration do |table_name, columns, options|
          next if ActiveRecord::Base.connection.index_exists?(table_name, columns, options)

          ActiveRecord::Base
            .connection
            .add_index(table_name, columns, options)

          logger.info "Index of #{table_name} on #{columns} created"
        end
      end

      def log_indexes_creation_starts(ctx, logger:, **)
        logger.info 'Indexes creation starts'
      end

      def log_indexes_created(ctx, logger:, **)
        logger.info 'All indexes created'
      end
    end
  end
end
