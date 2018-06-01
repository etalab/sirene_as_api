require 'nokogiri'
require 'open-uri'

class GetLastMonthlyStockLink < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log 'Visiting monthly stock distant directory'
    interactor.call
    stdout_success_log "Computed last monthly stock link name : #{context.link}"
    puts
  end

  def call
    last_monthly_stock_relative_link = "#{current_year}-#{last_month}/geo_sirene.csv.gz"
    last_monthly_stock_relative_link = "#{last_year}-12/geo_sirene.csv.gz" if current_month == '01'

    context.link = "#{files_repository}/#{last_monthly_stock_relative_link}"
  end

  private

  def sirene_update_and_stock_links
    doc = Nokogiri::HTML(open(files_repository))
    links = doc.css('a')
    links
  end

  def files_domain
    'http://data.cquest.org'
  end

  def files_repository
    "#{files_domain}/geo_sirene"
  end

  def select_stock_relative_links
    sirene_update_and_stock_links.select do |l|
      l[:href].match(sirene_monthly_stock_filename_pattern)
    end
  end

  def select_stock_relative_links_edge_case_january
    sirene_update_and_stock_links.select do |l|
      l[:href].match(sirene_january_stock_filename_pattern)
    end
  end

  def sirene_monthly_stock_filename_pattern
    /.*sirene_#{current_year}([0-9]{2})_L_M\.csv.gz/
  end

  def sirene_january_stock_filename_pattern
    /.*sirene_#{last_year}([0-9]{2})_L_M\.csv.gz/
  end
end


# def link_uploaded?
#   uri = URI.parse(context.link)
#   http = Net::HTTP.new(uri.host)
#   header = http.request_head(uri.request_uri)
#   header.is_a? Net::HTTPSuccess
# end