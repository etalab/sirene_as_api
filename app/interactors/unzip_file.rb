require 'open3'

class UnzipFile < SireneAsAPIInteractor
  around do |interactor|
    interactor.call

    puts
  end

  def call
    context.unzipped_files = []

    stdout_info_log "Started unzipping #{filepath} into #{unzipped_file_path}"

    if unzipped_file_path.exist?
      context.unzipped_files << unzipped_file_path.to_s
      stdout_warn_log "Skipping unzip of file #{filepath.basename} already a file at destination #{unzipped_file_path}"
    else
      unzip
    end
  end

  def unzip
    _stdout, stderr, status = Open3.capture3 "gunzip -k #{filepath}"

    if status.success?
      context.unzipped_files << unzipped_file_path.to_s
      stdout_success_log "Unzipped file #{unzipped_file_path} successfully"
    else
      stdout_error_log "Failed to unzip file (error: #{stderr})"
    end
  end

  def filepath
    @filepath ||= Pathname.new(context.filepath)
  end

  def unzipped_file_path
    @unzipped_file_path ||= Pathname.new(filepath.dirname + filepath.basename('.gz'))
  end
end
