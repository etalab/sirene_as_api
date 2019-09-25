class ImportStockJob < ApplicationJob
  queue_as :stock

  def perform(stock_id)
    @stock = Stock.find stock_id
    @logger = @stock.logger_for_import
    @stock.update status: 'LOADING'

    import
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
end
