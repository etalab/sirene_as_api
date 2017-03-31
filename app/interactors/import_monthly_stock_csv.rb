class ImportMonthlyStockCsv
  include Interactor

  def call
    quietly do
      stdout_etablissement_count_change do
        stdout_benchmark_stats do

          binding.pry
          SmarterCSV.process(context.unzipped_files.first, csv_options) do |chunk|
            InsertEtablissementRowsJob.new(chunk).perform
          end

        end
      end
    end
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

  def quietly
    log_level_before_block_execution = Rails.logger.level

    Rails.logger.level = :fatal
    yield
    Rails.logger.level = log_level_before_block_execution
  end

  def stdout_etablissement_count_change
    etablissement_count_before = Etablissement.count
    yield
    etablissement_count_after = Etablissement.count

    entries_added = etablissement_count_after - etablissement_count_before

    puts "#{entries_added} etablissements added"
  end

  def stdout_benchmark_stats
    Benchmark.bm(7) do |x|
      x.report(:csv_pro) do
        yield
      end
    end
  end
end
