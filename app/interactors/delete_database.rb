class DeleteDatabase < SireneAsAPIInteractor
  def call
    stdout_info_log('Deleting database...')
    EtablissementV2.delete_all
  end
end
