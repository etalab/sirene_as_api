class SolrBuildDictionary < SireneAsAPIInteractor
  around do
    if context.rebuilding_database || !context.links.empty?
      stdout_info_log 'Indexing finished ! Starting dictionary build...'
      `RAILS_ENV=#{Rails.env} bundle exec rake sirene_as_api:build_dictionary`
    end
  end
end
