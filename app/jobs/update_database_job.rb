class UpdateDatabaseJob < ApplicationJob
  queue_as :auto_updates

  def perform
    Stock::Operation::UpdateDatabase.call logger: Rails.logger
  end
end
