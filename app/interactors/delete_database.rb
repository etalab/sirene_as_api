class DeleteDatabase < SireneAsAPIInteractor
  def call
    stdout_info_log('Deleting database...')
    Etablissement.delete_all
  end
end
