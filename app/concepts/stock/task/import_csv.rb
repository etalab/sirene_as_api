class Stock
  module Task
    class ImportCSV < Trailblazer::Operation
      pass :log_import_start
      step :file_exists?
      fail :log_file_not_found
      step :file_importer
      step :import_csv
      pass :log_import_completed

      CHUNK_SIZE = 10_000

      def file_exists?(_, csv:, **)
        File.exist? csv
      end

      def file_importer(ctx, logger:, **)
        ctx[:file_importer] = Files::Helper::FileImporter.new(logger)
      end

      # rubocop:disable Metrics/ParameterLists
      def import_csv(_, csv:, model:, file_importer:, logger:, **)
        file_importer.bulk_import(file: csv, model: model) do |imported_row_count|
          break unless imported_row_count

          logger.info "#{imported_row_count} rows imported"
        end
      end
      # rubocop:enable Metrics/ParameterLists

      def log_import_start(_, csv:, logger:, **)
        logger.info "Import starting for file #{csv}"
      end

      def log_file_not_found(_, logger:, csv:, **)
        logger.error "File not found: #{csv}"
      end

      def log_import_completed(_, logger:, **)
        logger.info 'Import completed.'
      end

      private

      def basic_options
        {
          chunk_size: CHUNK_SIZE,
          col_sep: ',',
          row_sep: "\n",
          downcase_header: false,
          convert_values_to_numeric: false,
          remove_empty_values: false,
          file_encoding: 'UTF-8'
        }
      end
    end
  end
end
