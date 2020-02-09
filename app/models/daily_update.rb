class DailyUpdate < ApplicationRecord
  def self.current
    where(update_type: 'limited')
      .order(to: :desc, created_at: :desc)
      .first
  end

  def completed?
    status == 'COMPLETED'
  end

  def logger_for_import
    Logger.new logger_file_path.to_s
  end

  def logger_file_path
    Rails.root.join 'log', log_filename
  end
end
