class AutomaticUpdateDatabase
  include Interactor::Organizer

  organize SetAutomaticContext, UpdateDatabase, DeleteTemporaryFiles
end
