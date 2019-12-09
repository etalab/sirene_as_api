class DailyUpdateModelJob < ApplicationJob
  queue_as :auto_updates

  def perform(model_name)
  end
end
