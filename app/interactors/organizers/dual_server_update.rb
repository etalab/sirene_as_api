class DualServerUpdate
  include Interactor::Organizer

  organize CheckCurrentService, AutomaticUpdateDatabase, TestSelfServer, SwitchServer
end
