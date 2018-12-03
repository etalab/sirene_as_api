class SolrBuildDictionary < SireneAsAPIInteractor
  # context.links.nil => we dont call from the update interactor
  around do
    if context.rebuilding_database || context.links.nil? || !context.links.empty?
      stdout_info_log 'Indexing finished ! Starting dictionary build...'
      `RAILS_ENV=#{Rails.env} bundle exec rake sirene_as_api:build_dictionary`
    end
  end
end
