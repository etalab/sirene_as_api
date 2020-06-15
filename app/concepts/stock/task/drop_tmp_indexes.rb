class Stock
  module Task
    class DropTmpIndexes < Trailblazer::Operation
      include Stock::Helper::DatabaseIndexes

      step :table_name_unite_legale
      step :drop_indexes
      step :log_indexes_dropped

      step :table_name_etablissement
      step :drop_indexes
      step :log_indexes_dropped

      def table_name_unite_legale(ctx, **)
        ctx[:table_name] = UniteLegale.table_name
      end

      def table_name_etablissement(ctx, **)
        ctx[:table_name] = Etablissement.table_name
      end

      def drop_indexes(_, table_name:, **)
        each_index_configuration do |index_table_name, columns|
          temp_table_name = "#{table_name}_tmp"
          next if index_table_name.to_s != table_name
          next unless ActiveRecord::Base.connection.index_exists?(temp_table_name, columns)

          ActiveRecord::Base
            .connection
            .remove_index temp_table_name, column: columns
        end
      end

      def log_indexes_dropped(_ctx, logger:, **)
        logger.info 'Indexes dropped'
      end
    end
  end
end
