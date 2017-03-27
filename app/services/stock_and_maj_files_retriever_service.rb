require 'nokogiri'
require 'open-uri'

class StockAndMajFilesRetrieverService
  include Singleton

  class << self
    def needed_files
      sirene_update_and_stock_links.select do |l|
        l[:href].match(sirene_daily_update_filename_pattern)
        day_number = $1

        needed_padded_days_numbers.include?(day_number)
      end
    end

    def sirene_update_and_stock_links
      doc = Nokogiri::HTML(open(files_repository))
      links = doc.css('a')
    end

    def sirene_daily_update_filename_pattern
      /.*sirene_#{Time.now.year}([0-9]{3})_E_Q\.zip/
    end

    def needed_padded_days_numbers
      # Insee release data the day after it was produced
      now = Time.now
      yesterday = Time.now - 1.day

      current_month_first_day = Time.new(now.year,now.month,1)

      (current_month_first_day.yday..yesterday.yday).to_a.map{ |dn| dn.to_s.rjust(3,'0') }
    end

    def last_monthly_stock_zip_file_name
      # Insee releases a new stock file at the beginning of each month
      # TODO check if it is not released yet
      padded_month_number = Time.now.month.to_s.rjust(2,'0')
      year = Time.now.year.to_s

      "sirene_#{year}#{padded_month_number}_L_M.zip"
    end

    def sirene_monthly_stock_filename_pattern
      /.*sirene_#{Time.now.year}([0-9]{2})_L_M\.zip/
    end

    def files_repository
      'http://files.data.gouv.fr/sirene'
    end
  end
end
