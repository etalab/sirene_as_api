module Files
  module Helper
    class CSVReader
      def initialize(logger)
        @logger = logger
      end

      def bulk_processing(file, model)
        @model = model

        SmarterCSV.process(file, options) { |chunk| yield chunk }
      rescue SmarterCSV::SmarterCSVException, ArgumentError
        @logger.error $ERROR_INFO.message
        yield false
      end

      private

      def chunk_size
        Stock::Task::ImportCSV::CHUNK_SIZE
      end

      # rubocop:disable Metrics/MethodLength
      def options
        {
          chunk_size: chunk_size,
          hash_transformations: :none,
          header_validations: [required_headers: @model.header_mapping.values],
          header_transformations: [
            :none,
            key_mapping: @model.header_mapping
          ],
          col_sep: ',',
          row_sep: "\n",
          force_utf8: true
        }
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
