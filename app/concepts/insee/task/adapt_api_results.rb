module INSEE
  module Task
    class AdaptApiResults < Trailblazer::Operation
      pass :log_adapt_starts
      step :adapt_api_results
      fail :log_adapter_failed
      pass :log_adapt_done

      def adapt_api_results(ctx, daily_update:, api_results:, **)
        ctx[:results] = []
        api_results.each do |result|
          operation = daily_update.adapter_task.call result: result

          if operation.failure?
            ctx[:failing_item] = result
            break
          end

          ctx[:results] << operation[:result]
        end
      end

      def log_adapt_starts(_, logger:, **)
        logger.info 'Adapting INSEE response starts'
      end

      def log_adapt_done(_, logger:, **)
        logger.info 'Adapting done'
      end

      def log_adapter_failed(_, adapter:, failing_item:, logger:, **)
        logger.error "#{adapter} failed for result #{failing_item}"
      end
    end
  end
end
