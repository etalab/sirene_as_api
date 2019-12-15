module INSEE
  module Operation
    class FetchUpdates < Trailblazer::Operation
      step :init_api_results
      step :fetch_with_cursor
      step :log_entitites_fetched
      fail :log_operation_failure

      CURSOR_START_VALUE = '*'.freeze

      def init_api_results(ctx, **)
        ctx[:api_results] = []
      end

      # rubocop:disable Metrics/MethodLength
      def fetch_with_cursor(ctx, **)
        current_cursor = CURSOR_START_VALUE
        operation = nil

        loop do
          operation = fetch_operation(ctx, current_cursor)
          break if operation.failure?

          body = operation[:body]
          api_results = body[operation[:api_results_key]]

          ctx[:api_results] += api_results

          current_cursor = body[:header][:curseurSuivant]

          break if end_reached?(body[:header])
        end

        operation.success?
      end
      # rubocop:enable Metrics/MethodLength

      def log_entitites_fetched(_, model:, api_results:, logger:, **)
        logger.info "Total: #{api_results.size} #{model} fetched"
      end

      def log_operation_failure(_, model:, logger:, **)
        logger.error "Fetching new #{model} failed"
      end

      private

      def fetch_operation(context, current_cursor)
        INSEE::Request::FetchUpdatesWithCursor.call(
          model: context[:model],
          from: context[:from],
          to: context[:to],
          cursor: current_cursor,
          logger: context[:logger]
        )
      end

      def end_reached?(header)
        header[:curseur] == header[:curseurSuivant]
      end
    end
  end
end
