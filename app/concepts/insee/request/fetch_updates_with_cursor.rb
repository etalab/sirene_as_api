module INSEE
  module Request
    class FetchUpdatesWithCursor < Trailblazer::Operation
      step Nested Operation::RenewToken

      step :set_api_results_key
      step :set_route_insee
      step :set_query_filter
      step :set_query_hash

      step :build_url
      step :build_http
      step :build_request

      step :fetch_api_results
      step :check_http_code
      fail :log_http_failed, fail_fast: true
      step :read_body
      fail :log_parsing_failed
      pass :log_http_get_success

      # value limited by INSEE
      MAX_ELEMENTS_PER_CALL = 1_000
      # 2019-06-01T00:00:00
      TIME_FORMAT = '%Y-%m-%dT%H:%M:%S'.freeze

      def set_api_results_key(ctx, model:, **)
        # UniteLegale => unitesLegales
        ctx[:api_results_key] = model.name
          .underscore.pluralize # pluralize only works on underscore
          .camelize(:lower).to_sym
      end

      def set_route_insee(ctx, model:, **)
        ctx[:route_insee] = model == UniteLegale ? 'siren' : 'siret'
      end

      def set_query_filter(ctx, from:, to:, model:, **)
        from = from.strftime TIME_FORMAT
        to   = to.strftime TIME_FORMAT

        ctx[:query_filter] = "dateDernierTraitement#{model.name}:[#{from} TO #{to}]"
      end

      def set_query_hash(ctx, cursor:, query_filter:, **)
        ctx[:query_hash] = {
          nombre: MAX_ELEMENTS_PER_CALL,
          curseur: cursor,
          q: query_filter
        }
      end

      def build_url(ctx, route_insee:, query_hash:, **)
        url = URI(base_url + route_insee.to_s)
        url.query = URI.encode_www_form(query_hash)
        ctx[:url] = url
      end

      def build_http(ctx, url:, **)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        ctx[:http] = http
      end

      def build_request(ctx, url:, token:, **)
        request = Net::HTTP::Get.new(url)
        request['authorization'] = "Bearer #{token}"
        ctx[:request] = request
      end

      def fetch_api_results(ctx, http:, request:, **)
        ctx[:response] = http.request(request)
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

      def base_url
        'https://api.insee.fr/entreprises/sirene/V3/'
      end
    end
  end
end
