class StockConcept
  module Operation
    class PostImport < Trailblazer::Operation
      step :stock_unite_legale_imported?
      step :stock_etablissement_imported?
      step :both_stocks_of_same_month?
      fail :log_stock_not_imported, Output(:success) => End(:success)
      step Subprocess Task::RenameIndexes
      step Subprocess Task::CreateTmpIndexes
      step Subprocess Task::CreateAssociations
      step Subprocess Task::SwapTableNames
      step Subprocess Task::DropTmpIndexes
      step :truncate_temp_tables
      step Subprocess Task::UpdateNonDiffusable
      step :dual_server_update?
      fail :log_dual_server_update_disabled, Output(:success) => End(:success)
      step :switch_server
      step :log_server_switched

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
          StockConcept::Task::TruncateTable.call table_name: table_name, logger: logger
        end
      end

      def dual_server_update?(_, **)
        Rails.configuration.switch_server['perform_switch']
      end

      def switch_server(_, **)
        SwitchServer.call
      end

      def log_server_switched(_, logger:, **)
        logger.info 'IP Switch request made'
      end

      def log_dual_server_update_disabled(_, logger:, **)
        logger.info 'Dual server update disabled, skipping IP switch'
      end

      def log_stock_not_imported(_, logger:, **)
        logger.info 'Other import not finished'
      end
    end
  end
end
