class SolrReindex < SireneAsAPIInteractor
  def call
    stdout_info_log 'Starting Solr reindexing...'
    `RAILS_ENV=#{Rails.env} bundle exec rake sunspot:reindex`
  end
end
