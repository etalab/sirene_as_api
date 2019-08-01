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
        2_000
      end

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
          file_encoding: 'UTF-8'
        }
      end
    end
  end
end
