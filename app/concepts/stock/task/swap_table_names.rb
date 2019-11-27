class Stock
  module Task
    class SwapTableNames < Trailblazer::Operation
      pass :log_renaming_starts
      step :swap_unite_legale
      step :swap_etablissement
      pass :log_renaming_done

      def swap_unite_legale(_, **)
        swap_command(UniteLegale.table_name)
      end

      def swap_etablissement(_, **)
        swap_command(Etablissement.table_name)
      end

      def log_renaming_starts(_, logger:, **)
        logger.info 'Table renaming starts'
      end

      def log_renaming_done(_, logger:, **)
        logger.info 'Table renaming done'
      end

      private

      def swap_command(table_name)
        ActiveRecord::Base.connection.execute swap_sql(table_name)
      end

      def swap_sql(table_name)
        <<-END_SQL
        ALTER TABLE "#{table_name}" RENAME TO "#{table_name + '_swap'}";
        ALTER TABLE "#{table_name + '_tmp'}" RENAME TO "#{table_name}";
        ALTER TABLE "#{table_name + '_swap'}" RENAME TO "#{table_name + '_tmp'}";
        END_SQL
      end
    end
  end
end
