# TODO: Factorise for not having to copy model Etablissement every time

def without_solr_indexing
  allow_any_instance_of(Etablissement).to receive(:perform_index_tasks)
  yield
end
