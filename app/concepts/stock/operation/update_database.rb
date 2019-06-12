class Stock
  module Operation
    class UpdateDatabase < Trailblazer::Operation
#      step Nested Task::PreLoadChecks
#      step Nested Task::RetrieveLatestRemoteStock
#      step :remote_stock_newer?
#        fail :log_database_up_to_date, Output(:success) => 'End.success'
#      step :set_remote_uri
#      step :persist_stock
#      step Nested ::Files::Operation::Download
#      step Nested ::Files::Operation::Extract
#      step Nested Task::DropDatabase
#      step Nested Import
#      step Nested UpdateIndexes
#      step :delete_tmp_files
#      fail :delete_tmp_files

      def set_remote_uri(ctx, remote_stock:, **)
        ctx[:uri] = remote_stock.uri
      end

      def persist_stock(_, remote_stock:, **)
        remote_stock.save
      end

      def remote_stock_newer?(_, remote_stock:, current_stock:, **)
        return true if current_stock.nil?
        remote_stock.newer? current_stock
      end

      def log_database_up_to_date(_, logger:, **)
        logger.info 'Database up to date'
      end
    end
  end
end
