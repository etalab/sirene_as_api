require 'open-uri'
require 'zip'

class ImportMonthlyEtablissementsStockService
  include Singleton

  class << self
    def call
      retrieve_stock_download_link
      download_link
      extract_zip
      import_csv
    end

    def retrieve_stock_download_link
      stock_download_path = 'http://files.data.gouv.fr'
      stock_filename = StockAndMajFilesRetrieverService.last_monthly_stock_zip_filename
      @stock_download_link = [stock_download_path, stock_filename].join('')
    end

    def download_link
      filename = @stock_download_link.gsub('http://files.data.gouv.fr/sirene','')
      @stock_zipfile_local_path = "./public/#{filename}"

      unless File.exist(@stock_zipfile_local_path) do
        download = open(@stock_download_link)
        IO.copy_stream(download, @stock_zipfile_local_path)
      end
    end

    def extract_zip
      destination = 'public/'

      Zip::File.open(@stock_zipfile_local_path) do |zip_file|
        zip_file.each do |f|
          csv_path = File.join(destination, f.name)
          unless File.exist(csv_path)
            zip_file.extract(f, csv_path)
          end
        end
      end
    end

    def csv_path
      @stock_csvfile_local_pathcsv
    end

    def csv_path=(value)
      @stock_csvfile_local_pathcsv = value
    end

    def import_csv(options = {})
      Rails.logger.level = :fatal if options[:quiet]

      etablissement_count_before = Etablissement.count

      # IMPORT
      Benchmark.bm(7) do |x|
        x.report(:csv_pro) do
          SmarterCSV.process(csv_path, csv_options) do |chunk|
            j = InsertEtablissementRowsJob.new(chunk)
            j.perform
          end
        end
      end

      etablissement_count_after = Etablissement.count
      entries_added = etablissement_count_after - etablissement_count_before

      puts "#{entries_added} etablissements added"
    end

    def csv_options
      {
        chunk_size: 10000,
        col_sep: ';',
        row_sep: "\r\n",
        convert_values_to_numeric: false,
        key_mapping: {},
        file_encoding: 'windows-1252'
      }
    end
  end
end
