class Stock
  module Operation
    class PostImport < Trailblazer::Operation
      step :stock_unite_legale_imported?
      step :stock_etablissement_imported?
      fail :log_stock_not_imported, Output(:success) => 'End.success'
      step Nested Task::CreateIndexes
      pass :log_associations_starts
      step :create_associations
      pass :log_associations_completed

      def stock_unite_legale_imported?(_ctx, **)
        StockUniteLegale.current&.imported?
      end

      def stock_etablissement_imported?(_ctx, **)
        StockEtablissement.current&.imported?
      end

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

      def log_stock_not_imported(_ctx, logger:, **)
        logger.info 'Other import not finished'
      end

      private

      def sql
        <<-END_SQL
        UPDATE etablissements
        SET unite_legale_id = unites_legales.id
        FROM unites_legales
        WHERE etablissements.siren = unites_legales.siren
        END_SQL
      end
    end
  end
end
