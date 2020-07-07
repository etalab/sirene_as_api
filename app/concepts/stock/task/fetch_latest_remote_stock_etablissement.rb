require 'nokogiri'
require 'open-uri'

class Stock
  module Task
    class FetchLatestRemoteStockEtablissement < Trailblazer::Operation
      step :fetch_latest_link
      step :build_stock_from_link

      def fetch_latest_link(ctx, logger:, **)
        ctx[:stock_link] = geo_sirene_url
      rescue OpenURI::HTTPError
        logger.error "Error while retrieving remote links: #{$ERROR_INFO.message}"
        false
      end

      def build_stock_from_link(ctx, stock_link:, **)
        year, month = stock_link.match(%r{(\d{4})-(\d{2})/}).captures
        ctx[:remote_stock] = StockEtablissement.new(
          year: year,
          month: month,
          status: 'PENDING',
          uri: stock_link
        )
      end

      private

      def geo_sirene_url
        "#{base_uri}/#{geo_sirene_folder}/#{latest_month_folder}#{filename}"
      end

      def latest_month_folder
        html
          .css('a')
          .map { |a| a[:href] }
          .select { |href| href =~ year_month_pattern }
          .last
      end

      def html
        Nokogiri::HTML full_uri.open
      end

      def full_uri
        URI.parse "#{base_uri}/#{geo_sirene_folder}"
      end

      def base_uri
        'https://files.data.gouv.fr'
      end

      def filename
        'StockEtablissement_utf8_geo.csv.gz'
      end

      def geo_sirene_folder
        'geo-sirene'
      end

      def year_month_pattern
        %r{^\d{4}-\d{2}/$}
      end
    end
  end
end
