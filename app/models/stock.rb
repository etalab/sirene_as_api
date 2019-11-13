class Stock < ApplicationRecord
  def self.current
    order(year: :desc, month: :desc, created_at: :desc).first
  end

  def imported?
    status == 'COMPLETED'
  end

  def importable?
    database_empty? ||
      newer_than_current_stock? ||
      current_stock_errored?
  end

  def newer?(other)
    date > other.date
  end

  def date
    Date.new(year.to_i, month.to_i)
  end

  def logger_for_import
    Logger.new logger_file_path
  end

  def logger_file_path
    Rails.root.join 'log', "#{self.class.to_s.underscore}.log"
  end

  private

  def database_empty?
    self.class.none?
  end

  def newer_than_current_stock?
    newer?(self.class.current)
  end

  def current_stock_errored?
    self.class.current.status == 'ERROR'
  end
end
