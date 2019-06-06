require 'open3'

module Files
  module Operation
    class Extract < Trailblazer::Operation
      step :setup_context
      step :gunzip
      fail :log_gunzip_failed

      def setup_context(ctx, path:, **)
        ctx[:unzipped_file] = "#{Rails.root}/tmp/files/#{Pathname.new(path).basename('.gz')}"
      end

      def gunzip(ctx, path:, unzipped_file:, **)
        _stdout, stderr, status = ::Open3.capture3 "gunzip -c #{path} > #{unzipped_file}"
        ctx[:gzip_stderr] = stderr
        status.success?
      end

      def log_gunzip_failed(ctx, gzip_stderr:, **)
        ctx[:error] = gzip_stderr
      end
    end
  end
end
