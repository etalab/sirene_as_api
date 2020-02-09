class Stock
  module Operation
    class PostImport < Trailblazer::Operation
      step :stock_unite_legale_imported?
      step :stock_etablissement_imported?
      fail :log_stock_not_imported, Output(:success) => 'End.success'
      step Nested Task::CreateAssociations
      step Nested Task::DropIndexes
      step Nested Task::SwapTableNames
      step Nested Task::CreateIndexes
      step :truncate_temp_tables

      def stock_unite_legale_imported?(_, **)
        StockUniteLegale.current&.imported?
      end

      def stock_etablissement_imported?(_, **)
        StockEtablissement.current&.imported?
      end

      def truncate_temp_tables(_, logger:, **)
        %w[unites_legales_tmp etablissements_tmp].each do |table_name|
          Stock::Task::TruncateTable.call table_name: table_name, logger: logger
        end
      end

      def log_stock_not_imported(_, logger:, **)
        logger.info 'Other import not finished'
      end
    end
  end
end
