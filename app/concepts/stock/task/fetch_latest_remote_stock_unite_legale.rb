require 'nokogiri'
require 'open-uri'

class Stock
  module Task
    class FetchLatestRemoteStockUniteLegale < Trailblazer::Operation
      step :fetch_latest_link
      step :build_stock_from_link

      def fetch_latest_link(ctx, **)
        ctx[:stock_link] = unite_legale_url
      end

      def build_stock_from_link(ctx, stock_link:, logger:, **)
        ctx[:remote_stock] = StockUniteLegale.new(
          year: year,
          month: month,
          status: 'PENDING',
          uri: stock_link
        )
      rescue OpenURI::HTTPError
        logger.error "Error while retrieving remote links: #{$ERROR_INFO.message}"
        false
      end

      private

      def unite_legale_url
        'https://files.data.gouv.fr/insee-sirene/StockUniteLegale_utf8.zip'
      end

      def year
        latest_stock_link[1]
      end

      def month
        french_months[french_month.to_sym]
      end

      def french_month
        latest_stock_link.first
      end

      # rubocop:disable Naming/VariableNumber
      def latest_stock_link
        html
          .css('h4')
          .map { |h4| h4.children.text }
          .find { |h4| h4 =~ /Sirene : Fichier StockUniteLegale du+/ }
          .match(/Sirene : Fichier StockUniteLegale du \d{2} (.+) (\d{4})/)
          .captures
      end
      # rubocop:enable Naming/VariableNumber

      def html
        Nokogiri::HTML data_gouv_uri.open
      end

      def data_gouv_uri
        URI.parse base_uri + '/fr/datasets/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret'
      end

      def base_uri
        'https://www.data.gouv.fr'
      end

      # rubocop:disable Metrics/MethodLength
      def french_months
        {
          janvier: '01',
          février: '02',
          mars: '03',
          avril: '04',
          mai: '05',
          juin: '06',
          juillet: '07',
          août: '08',
          septembre: '09',
          octobre: '10',
          novembre: '11',
          décembre: '12'
        }
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
