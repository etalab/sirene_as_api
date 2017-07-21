require 'nokogiri'
require 'open-uri'

class GetRelevantPatchesLinks < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log 'Visiting frequent update patches distant directory'
    interactor.call
    stdout_success_log "Found #{context.links.size} patches !
    Retrieved relevant patches links : #{context.links}"
    puts
  end

  def call
    relevant_patches_relative_links =
      sirene_update_and_stock_links.select do |l|
        l[:href].match(sirene_daily_update_filename_pattern)
        padded_day_number = $1
        padded_day_number && (padded_day_number > padded_latest_etablissement_mise_a_jour_day_number)
      end
    # If there are less than 5 patches, apply 5 patches anyway
    relevant_patches_relative_links = get_minimum_5_patches(relevant_patches_relative_links)

    relevant_patches_absolute_links = relevant_patches_relative_links.map do |relative_link|
      "#{files_domain}#{relative_link[:href]}"
    end

    context.links = relevant_patches_absolute_links
  end

  private

  def get_minimum_5_patches(links)
    if (links.size < 5)
      stdout_info_log "#{links.size} patch found; last 5 patch will be applied."
      links =
        sirene_update_and_stock_links.select do |l|
          l[:href].match(sirene_daily_update_filename_pattern)
        end
      links.last(5)
    else
      links
    end
  end

  def patches_relative_links
    sirene_update_and_stock_links.select do |l|
      l[:href].match(sirene_daily_update_filename_pattern)
    end
  end

  def sirene_update_and_stock_links
    doc = Nokogiri::HTML(open(files_repository))
    links = doc.css('a')
    return links
  end

  def padded_latest_etablissement_mise_a_jour_day_number
    @padded_latest_etablissement_mise_a_jour_day_number ||= begin
      stdout_info_log 'computing next patch that should be applied'
      latest_etablissement_mise_a_jour = Etablissement.latest_mise_a_jour
      day_number = Date.parse(latest_etablissement_mise_a_jour).yday
      padded_day_number = day_number.to_s.rjust(3,'0')
      stdout_success_log "Will try to apply patches #{padded_day_number.succ} and higher that are available
      See documentation for more on patches file names formatting"
      padded_day_number
    end
  end

  def files_domain
    'http://files.data.gouv.fr'
  end

  def files_repository
    "#{files_domain}/sirene"
  end

  def sirene_daily_update_filename_pattern
    /.*sirene_#{current_year}([0-9]{3})_E_Q\.zip/
  end

  def current_year
    Time.now.year.to_s
  end
end
