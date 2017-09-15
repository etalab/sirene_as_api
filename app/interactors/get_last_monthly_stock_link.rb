require 'nokogiri'
require 'open-uri'

class GetLastMonthlyStockLink < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log "Visiting monthly stock distant directory"
    interactor.call
    stdout_success_log "Retrieved last monthly stock link : #{context.link}"
    puts
  end

  def call
    last_monthly_stock_relative_link = stock_relative_links.map{ |sl| sl[:href] }.sort.last
    context.link = "#{files_domain}/#{last_monthly_stock_relative_link}"
  end

  private

  def stock_relative_links
    sirene_update_and_stock_links.select do |l|
      l[:href].match(sirene_monthly_stock_filename_pattern)
    end
  end

  def sirene_update_and_stock_links
    doc = Nokogiri::HTML(open(files_repository))
    links = doc.css('a')
  end

  def files_domain
    'http://files.data.gouv.fr'
  end

  def files_repository
    "#{files_domain}/sirene"
  end

  def sirene_monthly_stock_filename_pattern
    /.*sirene_#{current_year}([0-9]{2})_L_M\.zip/
  end

  def current_year
    Time.now.year.to_s
  end
end
