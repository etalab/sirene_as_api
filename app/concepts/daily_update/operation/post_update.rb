class DailyUpdate
  module Operation
    class PostUpdate < Trailblazer::Operation
      pass :log_update_starts
      step :unites_legales_updated?
      step :etablissements_updated?
      step Nested Task::CreateAssociations
      fail :log_update_failed, fail_fast: true
      step :log_update_done

      def unites_legales_updated?(_, **)
        DailyUpdateUniteLegale.current.completed?
      end

      def etablissements_updated?(_, **)
        DailyUpdateEtablissement.current.completed?
      end

      def log_update_starts(_, logger:, **)
        logger.info 'PostUpdate starts'
      end

      def log_update_done(_, logger:, **)
        logger.info 'PostUpdate done'
      end

      def log_update_failed(_, logger:, **)
        logger.error 'PostUpdate failed, an update is still running'
      end
    end
  end
end
