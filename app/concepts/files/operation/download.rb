require 'open3'

module Files
  module Operation
    class Download < Trailblazer::Operation
      extend ClassDependencies

      self[:destination_directory] = Rails.root.join 'tmp', 'files'

      pass :log_download_starts
      step :extract_filename
      step :download_file
      fail :log_error
      pass :log_download_completed

      def extract_filename(ctx, uri:, destination_directory:, **)
        filename = Pathname.new(uri).basename
        ctx[:file_path] = "#{destination_directory}/#{filename}"
      end

      def download_file(ctx, uri:, file_path:, **)
        _stdout, stderr, status = ::Open3.capture3 "curl #{uri} --location --fail --silent --show-error -o #{file_path}"

        ctx[:wget_error] = stderr
        status.success?
      end

      def log_error(_, logger:, wget_error:, **)
        logger.error "Download failed: #{wget_error}"
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
