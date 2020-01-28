module INSEE
  module Request
    class FetchUpdatesWithCursor < Trailblazer::Operation
      step Nested Operation::RenewToken

      step :set_api_results_key
      step :set_http_params

      step :fetch_api_results
      step :check_http_code
      fail :log_http_failed, fail_fast: true
      step :read_body
      fail :log_parsing_failed
      pass :log_http_get_success

      def set_api_results_key(ctx, model:, **)
        ctx[:api_results_key] = name_mapping[model.name.to_sym]
      end

      def set_http_params(ctx, **)
        ctx[:http_params] = {
          from: ctx[:from],
          to: ctx[:to],
          model: ctx[:model],
          cursor: ctx[:cursor],
          token: ctx[:token]
        }
      end

      def fetch_api_results(ctx, http_params:, **)
        ctx[:response] = ApiClient.new(http_params).call
      end

      def check_http_code(_, response:, **)
        response.code == '200'
      end

      def read_body(ctx, response:, **)
        ctx[:body] = JSON.parse(
          response.read_body,
          symbolize_names: true
        )
      end

      def log_http_get_success(_, body:, api_results_key:, logger:, **)
        logger.info "#{body[api_results_key].size} #{api_results_key} retrieved, new cursor: #{body[:header][:curseurSuivant]}"
      end

      def log_http_failed(_, response:, logger:, **)
        logger.error "HTTP request failed (code: #{response.code}): #{response.body}"
      end

      def log_parsing_failed(_, response:, logger:, **)
        logger.error "Body is not a valid JSON (#{response.body})"
      end

      private

      def name_mapping
        {
          UniteLegale: :unitesLegales,
          Etablissement: :etablissements
        }
      end
    end
  end
end
