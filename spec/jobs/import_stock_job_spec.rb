require 'rails_helper'

describe ImportStockJob, :trb do
  subject { described_class.perform_now stock_id }

  let(:logger) { instance_spy(Logger) }

  context 'when stock unite legale exists' do
    let(:stock) { create :stock_unite_legale, :pending }
    let(:stock_id) { stock.id }

    context 'when import operation is a success' do
      before do
        allow_any_instance_of(StockUniteLegale)
          .to receive(:logger_for_import)
          .and_return logger

        allow(Stock::Operation::Import)
          .to receive(:call)
          .and_return(trb_result_success)
      end

      context 'when post import operation is a success' do
        before do
          allow(Stock::Operation::PostImport)
            .to receive(:call)
            .and_return(trb_result_success)
        end

        it 'calls the import operation' do
          expect(Stock::Operation::Import)
            .to receive(:call)
            .with(stock: stock, logger: logger)
            .and_return(trb_result_success)
          subject
        end

        it 'changes the stock status to COMPLETED' do
          subject
          stock.reload
          expect(stock.status).to eq 'COMPLETED'
        end

        it 'calls PostImport at the end' do
          expect(Stock::Operation::PostImport)
            .to receive(:call)

          subject
        end
      end

      context 'when post import operation fails' do
        before do
          allow(Stock::Operation::PostImport)
            .to receive(:call)
            .and_return(trb_result_failure)
        end

        it 'set status to ERROR' do
          allow(Stock::Operation::Import)
            .to receive(:call)
            .and_return(trb_result_failure)

          subject
          stock.reload

          expect(stock.status).to eq 'ERROR'
        end
      end
    end

    describe 'when import operation fails' do
      it 'set status to ERROR' do
        allow(Stock::Operation::Import)
          .to receive(:call)
          .and_return(trb_result_failure)

        subject
        stock.reload

        expect(stock.status).to eq 'ERROR'
      end

      it 'does not call PostImport' do
        allow(Stock::Operation::Import)
          .to receive(:call)
          .and_return(trb_result_failure)

        expect(Stock::Operation::PostImport).not_to receive(:call)
        subject
      end
    end
  end

  context 'when stock does not exist' do
    let(:stock_id) { 1234 }

    it 'does not call the operation' do
      expect(Stock::Operation::Import)
        .not_to receive(:call)
      subject
    end

    it 'does not call PostImport' do
      expect(Stock::Operation::PostImport).not_to receive(:call)
      subject
    end

    it 'logs an error' do
      expect(Rails.logger).to receive(:error).with(/Couldn't find Stock with 'id'=1234/)
      subject
    end
  end
end
