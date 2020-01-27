require 'rails_helper'

describe SaveLastMonthlyStockName do
  include_context 'mute interactors'

  before(:all) do
    @test_folder = 'spec/fixtures/save_link_folder'
    @test_file = 'test_file.txt'
    FileUtils.remove_dir(@test_folder) if File.directory?(@test_folder)
  end

  after(:all) do
    FileUtils.remove_dir(@test_folder) if File.directory?(@test_folder)
  end

  context 'when asked to write the monthly stock name' do
    let(:test_link) { 'http://foobar_link.com' }
    it 'creates the folder if it doesnt exist' do
      allow_any_instance_of(described_class).to receive(:link_folder).and_return(@test_folder)
      allow_any_instance_of(described_class).to receive(:link_file).and_return(@test_file)
      described_class.call(link: test_link)

      expect(Dir.exist?(@test_folder)).to be true
    end

    it 'save the link to folder' do
      allow_any_instance_of(described_class).to receive(:link_folder).and_return(@test_folder)
      allow_any_instance_of(described_class).to receive(:link_file).and_return(@test_file)

      described_class.call(link: test_link)

      link_full_location = "#{@test_folder}/#{@test_file}"
      expect(File.exist?(link_full_location)).to be true

      link_inside = File.read(link_full_location)
      expect(link_inside).to eq(test_link)
    end
  end
end
