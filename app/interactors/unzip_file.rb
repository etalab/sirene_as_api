require 'zip'

class UnzipFile
  include Interactor

  around do |interactor|
    puts "------> Started unzipping #{context.filepath} into public/"
    interactor.call
    puts "------> SUCCESS File already existed or was unzipped properly #{context.filepath}"
  end

  def call
    destination = 'public/'

    context.unzipped_files = []

    Zip::File.open(context.filepath) do |zip_file|
      zip_file.each do |f|
        csv_path = File.join(destination, f.name)

        if File.exists?(csv_path)
          context.unzipped_files << csv_path
        else
          zip_file.extract(f, csv_path)
          context.unzipped_files << csv_path
        end

      end
    end
  end
end
