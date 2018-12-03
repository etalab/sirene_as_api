class SolrBuildDictionary < SireneAsAPIInteractor
  def call
    stdout_info_log 'Starting dictionary build...'
    `RAILS_ENV=#{Rails.env} bundle exec rake sirene_as_api:build_dictionary`
  end
end
