class UnzipFile < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log "Started unzipping #{context.filepath} into tmp/files/"

    interactor.call

    puts
  end

  def call
    destination = 'tmp/files/'

    context.unzipped_files = []

    Zlib::GzipReader::open(context.filepath) do |zip_file|
      unzipped_file_path = File.join(destination, zip_file.orig_name)

      if File.exist?(unzipped_file_path)
        context.unzipped_files << unzipped_file_path
        stdout_warn_log "Skipping unzip of file #{zip_file.orig_name} already a file at destination #{unzipped_file_path}"
      else
        f = File.new(unzipped_file_path, "w+")
        f.write(zip_file.read)
        f.close
        context.unzipped_files << unzipped_file_path
        stdout_success_log "Unzipped file #{unzipped_file_path} successfully"
      end
    end
  end
end
