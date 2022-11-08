class DailyUpdateJob < ApplicationJob
  queue_as :auto_updates

  def perform
    DailyUpdateConcept::Operation::UpdateDatabase.call logger: Rails.logger
  end
end
