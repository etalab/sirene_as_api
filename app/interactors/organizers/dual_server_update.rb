class DualServerUpdate
  include Interactor::Organizer

  organize AutomaticUpdateDatabase, TestSelfServer, SwitchServer
end
