class ApplyFrequentUpdateCsvPatch < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log 'Starting csv patch update'
    stdout_info_log 'Computing number of rows'

    context.csv_filename = context.unzipped_files.first
    context.number_of_rows = `wc -l #{context.csv_filename}`.split.first.to_i - 1

    stdout_success_log "Found #{context.number_of_rows} rows in patch"

    stdout_info_log 'Updating rows'

    quietly do
      stdout_benchmark_stats do
        interactor.call
      end
    end

    puts
  end

  def call
    progress_bar = ProgressBar.create(
      total: context.number_of_rows,
      format: 'Progress %c/%C |%b>%i| %a %e'
    )
    SmarterCSV.process(context.csv_filename, csv_options) do |chunk|
      UpdateEtablissementRowsJob.new(chunk).perform
      chunk.size.times { progress_bar.increment }
    end
  end

  def csv_options
    {
      chunk_size: 500,
      col_sep: ',',
      row_sep: "\r\n",
      # deprecated option in v2. This code will not be used anymore
      # convert_values_to_numeric: false,
      key_mapping: {},
      file_encoding: 'UTF-8'
    }
  end

  def quietly
    ar_log_level_before_block_execution = ActiveRecord::Base.logger.level
    ActiveRecord::Base.logger.level = :error

    log_level_before_block_execution = Rails.logger.level
    Rails.logger.level = :fatal

    Sunspot::Rails::LogSubscriber.logger = Rails.logger

    yield

    Rails.logger.level = log_level_before_block_execution

    ActiveRecord::Base.logger.level = ar_log_level_before_block_execution
  end

  def stdout_benchmark_stats
    Benchmark.bm(7) do |x|
      x.report(:csv_pro) do
        yield
      end
    end
  end
end
