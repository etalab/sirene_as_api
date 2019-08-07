require 'nokogiri'
require 'open-uri'
require 'net/http'

class GetLastMonthlyStockLink < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log 'Visiting monthly stock distant directory'
    fail_server_unavailable unless available?(files_domain)

    interactor.call

    stdout_success_log "Retrieved last monthly stock link name : #{context.link}"
    fail_link_unavailable unless available?(context.link)
    puts
  end

  # Current adress : http://data.cquest.org/geo_sirene/year-month/geo-sirene.csv.gz
  def call
    last_stock_month_folder = available_stocks_month_folders.last[:href]
    context.link = "#{files_repository}/#{last_stock_month_folder}etablissements_actifs.csv.gz"
  end

  private

  def fail_server_unavailable
    stdout_error_log "Error : distant directory #{files_domain} is unreachable."
    context.fail!
  end

  def fail_link_unavailable
    stdout_error_log "Error : #{context.link} could not be reached."
    context.fail!
  end

  def available?(link)
    uri = URI.parse(link)
    http = Net::HTTP.new(uri.host)
    header = http.request_head(uri.request_uri)
    header.is_a? Net::HTTPSuccess
  end

  def available_stocks_month_folders
    sirene_month_folders.select do |l|
      l[:href].match(sirene_month_folder_filename_pattern)
    end
  end

  def sirene_month_folders
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

  def sirene_month_folder_filename_pattern
    /\d{4}-\d{2}/
  end
end
