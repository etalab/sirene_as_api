class DailyUpdateModelJob < ApplicationJob
  queue_as :auto_updates

  def perform(daily_update_id)
    @daily_update_id = daily_update_id
    operation = nil

    daily_update.update(status: 'LOADING')

    execute_transaction(operation)
  end

  private

  def execute_transaction(operation)
    ActiveRecord::Base.transaction do
      operation = DailyUpdate::Operation::Update.call params

      raise ActiveRecord::Rollback unless operation.success?
    end

    if operation.success?
      daily_update.update(status: 'COMPLETED')
      DailyUpdate::Operation::PostUpdate.call logger: daily_update.logger_for_import
    else
      daily_update.update(status: 'ERROR')
    end
  end

  def params
    {
      daily_update: daily_update,
      logger: daily_update.logger_for_import
    }
  end

  def daily_update
    @daily_update ||= DailyUpdate.find(@daily_update_id)
  end
end
