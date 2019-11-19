class ImportStockJob < ApplicationJob
  queue_as :stock

  def perform(stock_id)
    @stock = Stock.find stock_id
    @logger = @stock.logger_for_import
    @stock.update status: 'LOADING'

    wrap_import_with_log_level(:fatal) do
      import
    end
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error $ERROR_INFO.message
  end

  private

  def import
    operation = nil
    ActiveRecord::Base.transaction do
      operation = Stock::Operation::Import.call(stock: @stock, logger: @logger)

      raise ActiveRecord::Rollback unless operation.success?

      @stock.update status: 'COMPLETED'
      Stock::Operation::PostImport.call logger: @logger
    end

    @stock.update(status: 'ERROR') if operation.failure?
  end

  def wrap_import_with_log_level(log_level)
    usual_log_level = ActiveRecord::Base.logger.level
    ActiveRecord::Base.logger.level = log_level
    yield
    ActiveRecord::Base.logger.level = usual_log_level
  end
end
