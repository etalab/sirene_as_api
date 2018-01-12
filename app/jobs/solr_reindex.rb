class SolrReindex < SireneAsAPIInteractor
  around do
    if context.rebuilding_database || !context.links.empty?
      stdout_info_log 'Database was modified. Starting Solr reindexing...'
      `rake sunspot:reindex`
      stdout_info_log 'Indexing finished ! Starting dictionary build...'
      `rake sirene_as_api:build_dictionary`
    end
  end
end
