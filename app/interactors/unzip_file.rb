class UnzipFile < SireneAsAPIInteractor
  around do |interactor|
    interactor.call

    puts
  end

  def call
    destination = 'tmp/files/'

    context.unzipped_files = []

    Zlib::GzipReader::open(context.filepath) do |input_stream|
      unzipped_file_path = File.join(destination, context.filename.chomp('.gz'))
      stdout_info_log "Started unzipping #{context.filepath} into #{unzipped_file_path}"

      if File.exist?(unzipped_file_path)
        context.unzipped_files << unzipped_file_path
        stdout_warn_log "Skipping unzip of file #{context.filename} already a file at destination #{unzipped_file_path}"
      else
        File.open(unzipped_file_path, "w+") do |output_stream|
          IO.copy_stream(input_stream, output_stream)
          output_stream.close
        end
        context.unzipped_files << unzipped_file_path
        stdout_success_log "Unzipped file #{unzipped_file_path} successfully"
      end
    end
  end
end
