class Stock < ApplicationRecord
  def self.current
    order(year: :desc, month: :desc, created_at: :desc).first
  end

  def imported?
    status == 'COMPLETED'
  end

  def importable?
    cases_always_import || (cases_maybe_import && !cases_avoid_import)
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

  def cases_always_import
    database_empty?
  end

  def cases_maybe_import
    newer_than_current_stock? || current_stock_errored?
  end

  def cases_avoid_import
    current_stock_busy?
  end

  def database_empty?
    self.class.none?
  end

  def current_stock_busy?
    current_status = self.class.current.status
    current_status == 'LOADING' || current_status == 'PENDING'
  end

  def newer_than_current_stock?
    newer?(self.class.current)
  end

  def current_stock_errored?
    self.class.current.status == 'ERROR'
  end
end
