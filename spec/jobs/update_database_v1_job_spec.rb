require 'rails_helper'

describe UpdateDatabaseV1Job do
  it 'calls the Stock::Operation::UpdateDatabase' do
    expect(AutomaticUpdateDatabase).to receive(:call)
    described_class.perform_now
  end
end
