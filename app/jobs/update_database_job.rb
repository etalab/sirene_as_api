class UpdateDatabaseJob < ApplicationJob
  queue_as :auto_updates

  def perform
    if dual_server_update?
      other_server_in_service = CheckCurrentService.call

      StockConcept::Operation::UpdateDatabase.call(logger: Rails.logger) if other_server_in_service.success?
    else
      StockConcept::Operation::UpdateDatabase.call(logger: Rails.logger)
    end
  end

  def dual_server_update?
    Rails.configuration.switch_server['perform_switch']
  end
end
