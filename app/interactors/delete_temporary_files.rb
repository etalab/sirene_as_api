class DeleteTemporaryFiles < SireneAsAPIInteractor
  include Interactor

  def call
    return unless context.success?

    stdout_info_log("Deleting files in #{temp_files_location}")
    Dir["#{temp_files_location}/*"].select { |f| looks_like_temporary_file(f) }.each do |file|
      File.delete(file)
      stdout_success_log("Deleted #{file}")
    end
  end

  def temp_files_location
    'tmp/files'
  end

  def looks_like_temporary_file(file)
    looks_like_csv_files(file) || looks_like_gz_file(file)
  end

  def looks_like_csv_files(file)
    # Csv file starting with sirc- + at least one number
    return true if File.extname(file) == '.csv' && File.basename(file).match(/^geo[-_]sirene_/)
  end

  def looks_like_gz_file(file)
    # Zip file starting with sirene_ + at least one number
    return true if File.extname(file) == '.gz' && File.basename(file).match(/^geo[-_]sirene_/)
  end
end
