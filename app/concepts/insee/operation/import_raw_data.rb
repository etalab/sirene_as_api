module INSEE
  module Operation
    class ImportRawData < Trailblazer::Operation
      step Nested Task::AdaptApiResults
      pass :log_supersede_starts
      step :supersede

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

      def log_supersede_starts(_, results:, logger:, **)
        logger.info "Supersede starts ; #{results.size} update to perform"
      end
    end
  end
end
