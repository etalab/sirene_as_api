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
        ctx[:loop_count] = 0
        loop do
          pg_result = ActiveRecord::Base.connection.execute(sql)
          updated_rows_count = pg_result.cmd_tuples
          break if updated_rows_count.zero?
          ctx[:loop_count] += 1
        end
        ctx[:loop_count].positive?
      rescue ActiveRecord::ActiveRecordError, StandardError
        ctx[:error] = $ERROR_INFO
        false
      end

      def sql
        <<-END_SQL
        UPDATE etablissements_tmp
        SET unite_legale_id = unites_legales_tmp.id
        FROM unites_legales_tmp
        WHERE etablissements_tmp.id IN (
            SELECT id from etablissements_tmp where unite_legale_id IS NULL LIMIT #{request_limit}
          )
          AND etablissements_tmp.siren = unites_legales_tmp.siren
        END_SQL
      end

      def request_limit
        5_000
      end
    end
  end
end
