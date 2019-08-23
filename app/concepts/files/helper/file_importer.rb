module Files
  module Helper
    class FileImporter
      def initialize(logger)
        @logger = logger
      end

      def bulk_import(file_reader_class: Files::Helper::CSVReader, file:, model:)
        file_reader = file_reader_class.new @logger

        file_reader.bulk_processing(file, model) do |chunk|
          if chunk
            result = model.import chunk, validate: false
            yield result.ids.size
          else
            yield false
            break
          end
        end
      end
    end
  end
end
