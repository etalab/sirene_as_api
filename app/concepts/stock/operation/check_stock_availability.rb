class Stock
  module Operation
    class CheckStockAvailability < Trailblazer::Operation
      step Nested Task::FetchLatestRemoteStockEtablissement
      step :check_file_presence
      fail :log_stock_etablissements_not_available, fail_fast: true

      step Nested Task::FetchLatestRemoteStockUniteLegale
      step :check_file_presence
      fail :log_stock_unites_legales_not_available

      def check_file_presence(_, remote_stock:, **)
        url = URI.parse(remote_stock.uri)
        http = Net::HTTP.new(url.host, url.port)

        if url.port == 443
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        request = Net::HTTP::Head.new(url)
        response = http.request(request)
        response.code == '200'
      end

      def log_stock_etablissements_not_available(_, logger:, **)
        logger.warn 'Stock etablissements not reachable'
      end

      def log_stock_unites_legales_not_available(_, logger:, **)
        logger.warn 'Stock unites legales not reachable'
      end
    end
  end
end
