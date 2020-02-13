class DailyUpdate
  module Operation
    class Update < Trailblazer::Operation
      pass :log_update_period
      step Nested INSEE::Operation::FetchUpdates
      step Nested INSEE::Task::AdaptApiResults
      pass :log_supersede_starts
      step :supersede
      pass :log_update_done

      def supersede(_, daily_update:, results:, logger:, **)
        results.each do |item|
          INSEE::Task::Supersede.call(
            model: daily_update.related_model,
            business_key: daily_update.business_key,
            data: item,
            logger: logger
          )
        end
      end

      def log_update_period(_, daily_update:, logger:, **)
        logger.info "Importing from #{daily_update.from} to #{daily_update.to}"
      end

      def log_supersede_starts(_, results:, logger:, **)
        logger.info "Supersede starts ; #{results.size} update to perform"
      end

      def log_update_done(_, daily_update:, logger:, **)
        logger.info "#{daily_update.related_model} updated until #{daily_update.to}"
      end
    end
  end
end
