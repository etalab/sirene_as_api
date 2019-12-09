class Stock
  module Task
    class CreateAssociations < Trailblazer::Operation
      pass :log_associations_starts
      step :create_associations
      pass :log_associations_completed

      def create_associations(_ctx, logger:, **)
        ActiveRecord::Base.connection.execute(sql)
      rescue ActiveRecord::ActiveRecordError
        logger.error "Association failed: #{$ERROR_INFO.message}"
        false
      end

      def log_associations_starts(_, logger:, **)
        logger.info 'Models associations starts'
      end

      def log_associations_completed(_, logger:, **)
        logger.info 'Models associations completed'
      end

      private

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
