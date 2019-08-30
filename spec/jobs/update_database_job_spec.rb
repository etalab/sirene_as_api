require 'rails_helper'

describe UpdateDatabaseJob do
  it 'calls the Stock::Operation::UpdateDatabase' do
    expect(Stock::Operation::UpdateDatabase).to receive(:call)
    described_class.perform_now
  end
end
