require 'open-uri'

class DownloadFile < SireneAsAPIInteractor
  around do |interactor|
    context.filepath = "./tmp/files/#{filename}"

    stdout_info_log "Attempting to download #{filename}"

    if File.exist?(context.filepath)
      stdout_warn_log "#{filename} already exists ! Skipping download"
    else
      interactor.call
      stdout_success_log "Downloaded #{filename} successfuly"
    end

    puts
  end

  def call
    download = open(context.link)
    IO.copy_stream(download, context.filepath)
  end

  private

  def filename
    URI(context.link).path.split('/').last
  end
end
