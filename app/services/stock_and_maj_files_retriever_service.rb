require 'nokogiri'
require 'open-uri'

class StockAndMajFilesRetrieverService
  include Singleton

  class << self
    def update_links_since_last_monthly_stock
      first_day_not_included_in_last_monthly_stock_day_number =
        Time.new(current_year, last_monthly_stock_month_number + 1).yday

      sirene_update_and_stock_links.select do |l|
        l[:href].match(sirene_daily_update_filename_pattern)
        day_number = $1.to_i

        day_number >= first_day_not_included_in_last_monthly_stock_day_number
      end
    end

    def sirene_update_and_stock_links
      doc = Nokogiri::HTML(open(files_repository))
      links = doc.css('a')
    end

    def sirene_daily_update_filename_pattern
      /.*sirene_#{current_year}([0-9]{3})_E_Q\.zip/
    end

    def sirene_monthly_stock_filename_pattern
      /.*sirene_#{current_year}([0-9]{2})_L_M\.zip/
    end

    def files_repository
      'http://files.data.gouv.fr/sirene'
    end

    def last_monthly_stock_zip_filename
      stock_links = sirene_update_and_stock_links.select do |l|
        l[:href].match(sirene_monthly_stock_filename_pattern)
      end

      stock_links.map{ |sl| sl[:href] }.sort.last
    end

    def last_monthly_stock_month_number
      last_monthly_stock_zip_filename.match(sirene_monthly_stock_filename_pattern)
      padded_month_number = $1.to_i
    end

    def current_year
      Time.now.year.to_s
    end
  end
end
