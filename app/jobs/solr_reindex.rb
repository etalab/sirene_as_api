class SolrReindex < SireneAsAPIInteractor
  around do
    if context.rebuilding_database || !context.links.empty?
      stdout_info_log('Database was modified. Starting Solr reindexing...')
      `rake sunspot:reindex` # REVIEW: need to specify environnement in production ?
    end
  end
end
