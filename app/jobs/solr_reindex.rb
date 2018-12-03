class SolrReindex < SireneAsAPIInteractor
  # context.links.nil => we dont call from the update interactor
  around do
    if context.rebuilding_database || context.links.nil? || !context.links.empty?
      stdout_info_log 'Database was modified. Starting Solr reindexing...'
      `RAILS_ENV=#{Rails.env} bundle exec rake sunspot:reindex`
    end
  end
end
