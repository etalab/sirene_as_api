class Stock < ApplicationRecord
  def self.current
    self.order(year: :desc, month: :desc).first
  end

  def imported?
    status == 'COMPLETED'
  end

  def newer?(old_stock)
    date >= old_stock.date
  end

  def date
    Date.new(year.to_i, month.to_i)
  end
end
