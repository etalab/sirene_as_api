module DailyUpdate
  module Task
    class AdaptApiResults < Trailblazer::Operation
      pass :log_adapt_starts
      step :set_adapter
      step :adapt_api_results
      fail :log_adapter_failed
      pass :log_adapt_done

      def set_adapter(ctx, model:, **)
        case model.name
        when UniteLegale.name
          ctx[:adapter] = DailyUpdate::Task::AdaptUniteLegale
        when Etablissement.name
          ctx[:adapter] = DailyUpdate::Task::AdaptEtablissement
        end
      end

      def adapt_api_results(ctx, adapter:, api_results:, **)
        ctx[:results] = []
        api_results.each do |result|
          operation = adapter.call result: result

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
