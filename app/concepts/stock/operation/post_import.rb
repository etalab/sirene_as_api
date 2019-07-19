class Stock
  module Operation
    class PostImport < Trailblazer::Operation
      step :stock_unite_legale_imported?
      step :stock_etablissement_imported?
      fail :log_stock_not_imported, Output(:success) => 'End.success'
      step :create_associations

      def stock_unite_legale_imported?(ctx, **)
        StockUniteLegale.current&.imported?
      end

      def stock_etablissement_imported?(ctx, **)
        StockEtablissement.current&.imported?
      end

      def create_associations(ctx, logger:, **)
        ActiveRecord::Base.connection.execute(sql)
      rescue ActiveRecord::ActiveRecordError
        logger.error "Association failed: #{$ERROR_INFO.message}"
        false
      end

      def log_stock_not_imported(ctx, logger:, **)
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
