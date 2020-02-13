class DailyUpdate
  module Operation
    class Update < Trailblazer::Operation
      pass :log_update_period
      step Nested INSEE::Operation::FetchUpdates
      pass :log_update_done

      def log_update_period(_, daily_update:, logger:, **)
        logger.info "Importing from #{daily_update.from} to #{daily_update.to}"
      end

      def log_update_done(_, daily_update:, logger:, **)
        logger.info "#{daily_update.related_model} updated until #{daily_update.to}"
      end
    end
  end
end
