require 'rails_helper'

# We delete temporary files only if they start with 'sirc-' AND finish with .csv
# Or start with 'sirene_' AND finish with .zip
describe DeleteTemporaryFiles do
  before(:each) do
    @test_folder = 'spec/fixtures/files_for_deletion_test'
    @files_to_delete = ['sirc-1234.csv', 'sirene_1234.zip']
    @files_to_keep = [
      'sirc-test.csv',
      'sirc_1234.csv',
      'sirc-134.zip',
      'sirene-1234.zip',
      'sirene_test.zip',
      'sirene_1234.csv'
    ]
    @all_files = @files_to_delete + @files_to_keep
    @all_files.each { |file| File.new("#{@test_folder}/#{file}", 'w+') }
  end

  context 'When there are files to delete and files not to delete' do
    let(:test_file_location) { 'spec/fixtures/files_for_deletion_test' }
    let(:context) { double(:context, success?: true) }
    it 'delete only the right files' do
      allow_any_instance_of(described_class).to receive(:temp_files_location).and_return(@test_folder)

      described_class.call

      leftover_files_names = Dir["#{@test_folder}/*"].map { |file| File.basename(file) }
      expect(leftover_files_names).to match_array(@files_to_keep)
    end
  end
end
