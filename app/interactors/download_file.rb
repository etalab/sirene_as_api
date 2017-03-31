require 'open-uri'

class DownloadFile
  include Interactor

  def call
    filename = URI(context.link).path.split('/').last

    context.filepath = "./public/#{filename}"

    unless File.exists?(context.filepath)
      download = open(context.link)
      IO.copy_stream(download, context.filepath)
    end
  end
end
