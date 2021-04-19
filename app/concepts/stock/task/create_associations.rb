class Stock
  module Task
    class CreateAssociations < Trailblazer::Operation
      pass :log_associations_starts
      step :create_associations
      fail :log_transaction_failed
      pass :log_associations_completed

      def create_associations(ctx, **)
        execute_transaction(ctx)
      end

      def log_associations_starts(_, logger:, **)
        logger.info 'Models associations starts'
      end

      def log_associations_completed(_, logger:, **)
        logger.info 'Models associations completed'
      end

      def log_transaction_failed(_, error:, logger:, **)
        logger.error "Association failed: #{error.message}"
      end

      private

      def execute_transaction(ctx)
        ActiveRecord::Base.connection.execute(sql)
      rescue ActiveRecord::ActiveRecordError
        ctx[:error] = $ERROR_INFO
        false
      end

      def sql
        <<-END_SQL
        UPDATE etablissements_tmp
        SET unite_legale_id = unites_legales_tmp.id
        FROM unites_legales_tmp
        WHERE etablissements_tmp.siren = unites_legales_tmp.siren
        END_SQL
      end
    end
  end
end
