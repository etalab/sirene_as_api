require 'zip'

class UnzipFile < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log "Started unzipping #{context.filepath} into tmp/files/"

    interactor.call

    puts
  end

  def call
    destination = 'tmp/files/'

    context.unzipped_files = []

    Zip::File.open(context.filepath) do |zip_file|
      zip_file.each do |f|
        unzipped_file_path = File.join(destination, f.name)

        if File.exist?(unzipped_file_path)
          context.unzipped_files << unzipped_file_path
          stdout_warn_log "Skipping unzip of file #{f.name} already a file at destination #{unzipped_file_path}"
        else
          zip_file.extract(f, unzipped_file_path)
          context.unzipped_files << unzipped_file_path
          stdout_success_log "Unzipped file #{unzipped_file_path} successfully"
        end
      end
    end
  end
end
