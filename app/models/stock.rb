class Stock < ApplicationRecord
  def self.current
    order(year: :desc, month: :desc, created_at: :desc).first
  end

  def database_empty?
    self.class.current.nil?
  end

  def imported?
    status == 'COMPLETED'
  end

  def importable?
    database_empty? ||
      newer_than_current_completed_stock? ||
      same_as_current_stock_errored?
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

  def newer_than_current_completed_stock?
    newer?(self.class.current) && self.class.current.imported?
  end

  def same_as_current_stock_errored?
    date == self.class.current.date && self.class.current.status == 'ERROR'
  end
end
