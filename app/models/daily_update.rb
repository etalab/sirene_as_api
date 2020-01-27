class DailyUpdate < ApplicationRecord
  def model_to_update
    model_name_to_update.camelize.constantize
  end

  def logger_for_import
    Logger.new logger_file_path.to_s
  end

  def logger_file_path
    Rails.root.join 'log', "daily_update_#{model_name_to_update}.log"
  end
end
