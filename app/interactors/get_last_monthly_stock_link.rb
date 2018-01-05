require 'nokogiri'
require 'open-uri'

class GetLastMonthlyStockLink < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log 'Visiting monthly stock distant directory'
    interactor.call
    stdout_success_log "Retrieved last monthly stock link : #{context.link}"
    puts
  end

  def call
    last_monthly_stock_relative_link = stock_relative_links.map { |sl| sl[:href] }.sort.last
    context.link = "#{files_repository}/#{last_monthly_stock_relative_link}"
  end

  private

  def stock_relative_links
    stock_relative_links =
      if current_month == '1'
        select_stock_relative_links_edge_case_january
      else
        select_stock_relative_links
      end
    stock_relative_links
  end

  def sirene_update_and_stock_links
    doc = Nokogiri::HTML(open(files_repository))
    links = doc.css('a')
    links
  end

  def files_domain
    'http://files.data.gouv.fr'
  end

  def files_repository
    "#{files_domain}/sirene"
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
    /.*sirene_#{current_year}([0-9]{2})_L_M\.zip/
  end

  def sirene_january_stock_filename_pattern
    /.*sirene_#{last_year}([0-9]{2})_L_M\.zip/
  end
end
