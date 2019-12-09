class DailyUpdateModelJob < ApplicationJob
  queue_as :auto_updates

  def perform(model_name)
    @model_name = model_name
    operation = nil
    ActiveRecord::Base.transaction do
      operation = DailyUpdate::Operation::Update.call params

      raise ActiveRecord::Rollback unless operation.success?
    end
  end

  private

  def params
    {
      model: model,
      logger: logger_for_import
    }
  end

  def model
    @model_name.camelize.constantize
  end

  def logger_for_import
    Logger.new logger_file_path.to_s
  end

  def logger_file_path
    Rails.root.join 'log', "daily_update_#{model.name.underscore}.log"
  end
end
