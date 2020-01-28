require 'open-uri'

module Files
  module Operation
    class Download < Trailblazer::Operation
      extend ClassDependencies

      self[:destination_directory] = Rails.root.join 'tmp', 'files'

      pass :log_download_starts
      step :extract_filename
      step :download_file
      pass :log_download_completed

      def extract_filename(ctx, uri:, destination_directory:, **)
        filename = Pathname.new(uri).basename
        ctx[:file_path] = "#{destination_directory}/#{filename}"
      end

      def download_file(_ctx, uri:, file_path:, logger:, **)
        uri = URI(uri)
        File.write file_path, uri.open.read, mode: 'wb'
      rescue OpenURI::HTTPError
        logger.error "Download failed: #{$ERROR_INFO.message}"
        false
      end

      def log_download_starts(_, uri:, logger:, **)
        logger.info "Download starts: #{uri}"
      end

      def log_download_completed(_, file_path:, logger:, **)
        logger.info "Download completed: #{file_path}"
      end
    end
  end
end
