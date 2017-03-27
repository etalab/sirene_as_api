require 'open-uri'
require 'zip'

$sirets_processed ||= []

class Etablissement < ApplicationRecord
  attr_accessor :csv_path

  searchable do
    text :nom_raison_sociale
  end

  def self.import_csv(options = {})
    Rails.logger.level = :fatal if options[:quiet]

    options = {
      chunk_size: 10000,
      col_sep: ';',
      row_sep: "\r\n",
      convert_values_to_numeric: false,
      key_mapping: {},
      file_encoding: 'windows-1252'
    }

    @csv_path = 'public/sirc-17804_9075_14211_2017020_E_Q_20170121_015800268.csv'
    #@csv_path = 'public/phat_dump_janvier.csv'

    etablissement_count_before = Etablissement.count

    # IMPORT
    Benchmark.bm(7) do |x|
      x.report(:csv_pro) do
        SmarterCSV.process(@csv_path, options) do |chunk|
          j = InsertEtablissementRowsJob.new(chunk)
          j.perform
          #InsertEtablissementRowsJob.perform_now(chunk)
        end
      end
    end

    ## CLEANUP
    #to_delete_entrprises_id = []
    #sirets_count = { }

    #$sirets_processed.each{ |s| sirets_count[s] ||= 0; sirets_count[s] += 1}
    #sirets_with_doublons = sirets_count.select{|_,v| v > 1 }.keys
    #sirets_with_doublons.each do |siret_doublon|
    #  # Keep only the last copy of it, we rely on id
    #  ids_etablissements_doublons = Etablissement.where(siret: siret_doublon).order(id: :asc).pluck(:id)
    #  ids_etablissements_doublons.pop

    #  to_delete_entrprises_id << ids_etablissements_doublons
    #end

    #to_delete_entrprises_id.flatten!
    #Etablissement.where(id: to_delete_entrprises_id).delete_all

    etablissement_count_after = Etablissement.count
    entries_added = etablissement_count_after - etablissement_count_before

    puts "#{entries_added} etablissements added"
  end

  def self.read_distant_base
    url = 'http://www.data.gouv.fr/fr/datasets/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/'
    body = Net::HTTP.get(URI.parse(url))
    links = body.scan(/<a itemprop="url" href=([^>]*)>/)
    last_link = links.first[0].delete('"')
    filename = last_link.gsub('http://files.data.gouv.fr/sirene/', '')
    download = open(last_link)
    IO.copy_stream(download, "public/#{filename}")
    Etablissement.extract_zip("public/#{filename}", 'public/')
    Etablissement.import_csv
  end

  def self.extract_zip(file, destination)
    Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        @csv_path = File.join(destination, f.name)
        zip_file.extract(f, @csv_path) unless File.exist?(@csv_path)
      end
    end
  end
end
