class UpdateDatabaseJob < ApplicationJob
  queue_as :auto_updates

  def perform(options = { safe: false })
    Stock::Operation::UpdateDatabase.call logger: Rails.logger, options: options
  end
end
