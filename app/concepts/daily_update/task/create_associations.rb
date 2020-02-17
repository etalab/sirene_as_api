class DailyUpdate
  module Task
    class CreateAssociations < Trailblazer::Operation
      pass :log_associations_starts
      step :create_associations
      fail :log_transaction_failed
      pass :log_associations_completed

      def create_associations(ctx, **)
        ActiveRecord::Base.transaction do
          execute_transaction(ctx)
        end
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
        raise ActiveRecord::Rollback
      end

      def sql
        <<-END_SQL
        UPDATE etablissements
        SET unite_legale_id = unites_legales.id
        FROM unites_legales
        WHERE etablissements.unite_legale_id is null and etablissements.siren = unites_legales.siren
        END_SQL
      end
    end
  end
end
