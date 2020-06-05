class UpdateDatabaseV1Job < ApplicationJob
  queue_as :auto_updates

  def perform
    AutomaticUpdateDatabase.call
  end
end
