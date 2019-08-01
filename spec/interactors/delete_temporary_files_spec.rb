require 'rails_helper'

# We delete temporary files only if they start with 'geo-sirene' AND finish with .csv or .csv.gz
describe DeleteTemporaryFiles do
  include_context 'mute interactors'

  before(:each) do
    @test_folder = 'spec/fixtures/files_for_deletion_test'
    @files_to_delete = [
      'geo-sirene_2017032_E_Q.csv',
      'geo-sirene_2017032_E_Q.csv.gz',
      'geo-sirene_1234.csv',
      'geo-sirene_1234.csv.gz',
      'geo_sirene_2012_12.csv.gz',
      'geo_sirene_2011_03.csv.gz'
    ]
    @files_to_keep = [
      'sirene-1234.csv.gz',
      'geo-sirene_test.zip',
      'unrelated.json',
      'keep_me.gz'
    ]
    @all_files = @files_to_delete + @files_to_keep
    @all_files.each { |file| File.new("#{@test_folder}/#{file}", 'w') }
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
