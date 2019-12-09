require 'rails_helper'

describe DailyUpdateJob do
  it 'calls the DailyUpdate::Operation::UpdateDatabase' do
    expect(DailyUpdate::Operation::UpdateDatabase).to receive(:call)
    described_class.perform_now
  end
end
