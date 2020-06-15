class Stock
  module Operation
    class PostImport < Trailblazer::Operation
      step :stock_unite_legale_imported?
      step :stock_etablissement_imported?
      step :both_stocks_of_same_month?
      fail :log_stock_not_imported, Output(:success) => 'End.success'
      step Nested Task::RenameIndexes
      step Nested Task::CreateTmpIndexes
      step Nested Task::CreateAssociations
      step Nested Task::SwapTableNames
      step Nested Task::DropTmpIndexes
      step :truncate_temp_tables
      step Nested Task::UpdateNonDiffusable

      def stock_unite_legale_imported?(_, **)
        StockUniteLegale.current&.imported?
      end

      def stock_etablissement_imported?(_, **)
        StockEtablissement.current&.imported?
      end

      def both_stocks_of_same_month?(_, **)
        stock_ul = StockUniteLegale.current
        stock_e = StockEtablissement.current
        stock_ul.year == stock_e.year && stock_ul.month == stock_e.month
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
