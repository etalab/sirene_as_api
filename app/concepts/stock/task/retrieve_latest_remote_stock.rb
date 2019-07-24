require 'nokogiri'
require 'open-uri'

class Stock
  module Task
    class RetrieveLatestRemoteStock < Trailblazer::Operation
      step :fetch_latest_link
      step :create_stock_from_link

      def fetch_latest_link(ctx, logger:, **)
        ctx[:stock_link] = geo_sirene_url
      rescue OpenURI::HTTPError
        logger.error "Error while retrieving remote links: #{$ERROR_INFO.message}"
        false
      end

      def create_stock_from_link(ctx, stock_link:, **)
        year, month = stock_link.match(/(\d{4})-(\d{2})\//).captures
        ctx[:remote_stock] = Stock.new(
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
        Nokogiri::HTML open "#{base_uri}/#{geo_sirene_folder}"
      end

      def base_uri
        "http://data.cquest.org"
      end

      def filename
        "StockEtablissement_utf8_geo.csv.gz"
      end

      def geo_sirene_folder
        "geo_sirene/v2019"
      end

      def year_month_pattern
        /^\d{4}-\d{2}\/$/
      end
    end
  end
end
