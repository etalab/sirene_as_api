class Stock
  module Task
    class CreateTmpIndexes < Trailblazer::Operation
      include Stock::Helper::DatabaseIndexes

      POSTGRES_INDEX_NAME_LENGTH_SIZE = 63

      pass :log_indexes_creation_starts
      step :create_indexes
      pass :log_indexes_created

      def create_indexes(_, logger:, **)
        each_index_configuration do |table_name, columns, options|
          temp_table_name = "#{table_name}_tmp"
          next if ActiveRecord::Base.connection.index_exists?(temp_table_name, columns, options)

          options[:name] = create_index_name(table_name, columns)

          ActiveRecord::Base
            .connection
            .add_index(temp_table_name, columns, options)

          logger.info "Index of #{temp_table_name} on #{columns} created"
        end
      end

      def log_indexes_creation_starts(_ctx, logger:, **)
        logger.info 'Indexes creation starts'
      end

      def log_indexes_created(_ctx, logger:, **)
        logger.info 'All indexes created'
      end

      private

      def create_index_name(table_name, columns)
        [
          'index',
          table_name,
          *columns
        ]
          .join('_')
          .first(index_name_max_length)
      end

      def index_name_max_length
        POSTGRES_INDEX_NAME_LENGTH_SIZE - 4 # '_tmp'.size
      end
    end
  end
end
