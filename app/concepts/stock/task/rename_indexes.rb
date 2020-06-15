class Stock
  module Task
    class RenameIndexes < Trailblazer::Operation
      include Stock::Helper::DatabaseIndexes

      step :table_name_unite_legale
      step :rename_indexes
      step :log_indexes_renamed

      step :table_name_etablissement
      step :rename_indexes
      step :log_indexes_renamed

      def table_name_unite_legale(ctx, **)
        ctx[:table_name] = UniteLegale.table_name
      end

      def table_name_etablissement(ctx, **)
        ctx[:table_name] = Etablissement.table_name
      end

      def rename_indexes(_, table_name:, **)
        each_index_configuration do |index_table_name, columns|
          next if index_table_name.to_s != table_name

          index_found = find_index_by(table_name: table_name, columns: columns)
          next if index_found.nil?

          ActiveRecord::Base
            .connection
            .rename_index table_name, index_found.name, "#{index_found.name}_tmp"
        end
      end

      def log_indexes_renamed(_ctx, table_name:, logger:, **)
        logger.info "Indexes of #{table_name} renamed"
      end

      private

      def find_index_by(table_name:, columns:)
        ActiveRecord::Base
          .connection
          .indexes(table_name)
          .find { |idx| idx.columns == columns }
      end
    end
  end
end
