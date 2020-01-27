class DailyUpdateJob < ApplicationJob
  queue_as :auto_updates

  def perform
    DailyUpdate::Operation::UpdateDatabase.call logger: Rails.logger
  end
end
