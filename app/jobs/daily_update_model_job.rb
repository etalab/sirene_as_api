class DailyUpdateModelJob < ApplicationJob
  queue_as :auto_updates

  def perform(daily_update_id)
    @daily_update_id = daily_update_id
    operation = nil

    daily_update.update(status: 'LOADING')

    ActiveRecord::Base.transaction do
      operation = DailyUpdate::Operation::Update.call params

      raise ActiveRecord::Rollback unless operation.success?

      daily_update.update(status: 'COMPLETED')
    end

    daily_update.update(status: 'ERROR') if operation.failure?
  end

  private

  def params
    {
      model: daily_update.model_to_update,
      from: daily_update.from,
      to: daily_update.to,
      logger: daily_update.logger_for_import
    }
  end

  def daily_update
    @daily_update ||= DailyUpdate.find(@daily_update_id)
  end
end
