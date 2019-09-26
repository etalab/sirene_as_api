require 'rails_helper'

describe UpdateDatabase do
  include_context 'mute interactors'

  context 'when there is no monthly stock link saved in a file' do
    it 'destroy and rebuild the database if user accepts it' do
      allow(File).to receive(:exist?).and_return(false)
      allow(STDIN).to receive(:gets).and_return('y')

      expect(DeleteDatabase).to receive(:call)
      expect(PopulateDatabase).to receive(:call)
      described_class.call
    end

    it 'doesnt destroy and rebuild the database if user doesnt accepts it' do
      allow(File).to receive(:exist?).and_return(false)
      allow(STDIN).to receive(:gets).and_return('n')

      expect(DeleteDatabase).not_to receive(:call)
      expect(PopulateDatabase).not_to receive(:call)
      described_class.call
    end
  end

  context 'when there is no monthly stock link saved in a file and its an automatic update' do
    it 'destroy and rebuild the database' do
      allow(File).to receive(:exist?).and_return(false)

      expect(STDIN).not_to receive(:gets)
      expect(DeleteDatabase).to receive(:call)
      expect(PopulateDatabase).to receive(:call)
      described_class.call!(automatic_update: true)
    end
  end
  context 'when there is a monthly stock link saved in a file' do
    it 'destroy and rebuild database if new link' do
      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:read).and_return('mock-link-201802')
      allow(GetLastMonthlyStockLink).to receive_message_chain(:call, link: 'mock-link-201809')

      expect(DeleteDatabase).to receive(:call)
      expect(PopulateDatabase).to receive(:call)
      described_class.call!(automatic_update: true)
    end
    it 'doesnt destroy and rebuild database if no new link' do
      empty_context = double(SelectAndApplyPatches)
      allow(empty_context).to receive(:links).and_return([])

      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:read).and_return('mock-link-201802')
      allow(GetLastMonthlyStockLink).to receive_message_chain(:call, link: 'mock-link-201802')
      allow(SelectAndApplyPatches).to receive(:call).and_return(empty_context)

      expect(DeleteDatabase).not_to receive(:call)
      expect(PopulateDatabase).not_to receive(:call)
      described_class.call!(automatic_update: true)
    end
    it 'select and apply patches if no new link' do
      empty_context = double(SelectAndApplyPatches)
      allow(empty_context).to receive(:links).and_return([])

      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:read).and_return('mock-link-201802')
      allow(GetLastMonthlyStockLink).to receive_message_chain(:call, link: 'mock-link-201802')

      expect(DeleteDatabase).not_to receive(:call)
      expect(PopulateDatabase).not_to receive(:call)
      expect(SelectAndApplyPatches).to receive(:call).and_return(empty_context)
      described_class.call!(automatic_update: true)
    end
  end
end
