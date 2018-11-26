class PostUpdateTasks
  include Interactor::Organizer

  organize SolrReindex, SolrBuildDictionary
end
