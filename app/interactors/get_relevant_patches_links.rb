require 'nokogiri'
require 'open-uri'

class GetRelevantPatchesLinks < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log 'Visiting frequent update patches distant directory'
    interactor.call

    if context.links.empty?
      stdout_success_log('No need to apply patches. Everything up-to-date.')
    else
      stdout_success_log "Found #{context.links.size} patches !
      Retrieved relevant patches links : #{context.links}"
      puts # REVIEW: ask about this line
    end
  end

  def call
    relevant_patches_relative_links = select_all_patches_after_(padded_latest_etablissement_mise_a_jour_day_number)

    unless context.we_are_rebuilding_database
      if there_is_less_than_5_patches_since_LM
        relevant_patches_relative_links = get_patches_since_LM
      else
        relevant_patches_relative_links = get_minimum_5_patches(relevant_patches_relative_links)
      end
    end

    relevant_patches_absolute_links = relevant_patches_relative_links.map do |relative_link|
      "#{files_domain}#{relative_link[:href]}"
    end
    context.links = relevant_patches_absolute_links
  end

  private

  def select_all_patches
    sirene_update_and_stock_links.select do |l|
      l[:href].match(sirene_daily_update_filename_pattern)
    end
  end

  def select_all_patches_after_(this_day)
    sirene_update_and_stock_links.select do |l|
      l[:href].match(sirene_daily_update_filename_pattern)
      padded_day_number = $1
      padded_day_number && (padded_day_number > this_day)
    end
  end

  def get_minimum_5_patches(links)
    if links.size.between?(1, 5)
      stdout_info_log "#{links.size} patch found; last 5 patches will be applied."
      select_all_patches.last(5)
    else
      links
    end
  end

  def there_is_less_than_5_patches_since_LM
    get_patches_since_LM.size < 5
  end

  def get_patches_since_LM
    # The following regexp catch the last 2 numbers of a string ergo the month
    last_month_stock_applied = /\d\d(?=[^\d])/.match(last_monthly_stock_name)[0]
    current_month = last_month_stock_applied.to_i + 1
    yday_beginning_current_month = Date.new(current_year.to_i, current_month, 01).yday
    beginning_current_month = yday_beginning_current_month.to_s.rjust(3, '0')

    select_all_patches_after_(beginning_current_month)
  end

  def last_monthly_stock_name
    File.read('.last_monthly_stock_name.txt')
  end

  def sirene_update_and_stock_links
    doc = Nokogiri::HTML(open(files_repository))
    links = doc.css('a')
  end

  def padded_latest_etablissement_mise_a_jour_day_number
    @padded_latest_etablissement_mise_a_jour_day_number ||= begin
      stdout_info_log 'Computing next patch that should be applied'
      latest_etablissement_mise_a_jour = Etablissement.latest_mise_a_jour
      day_number = Date.parse(latest_etablissement_mise_a_jour).yday
      padded_day_number = day_number.to_s.rjust(3, '0')
      stdout_info_log "Latest Etablissement in database is from patch #{padded_day_number}"
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
