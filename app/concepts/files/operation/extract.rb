require 'open3'

module Files
  module Operation
    class Extract < Trailblazer::Operation
      step :pathname
      step :extname
      step :extracted_file
      step :gunzip
      fail :log_gunzip_failed

      def pathname(ctx, file_path:, **)
        ctx[:pathname] = Pathname.new file_path
      end

      def extname(ctx, pathname:, **)
        ctx[:extname] = pathname.extname
      end

      def extracted_file(ctx, pathname:, **)
        extracted_filename = pathname.basename('.*')
        ctx[:extracted_file] = "#{Rails.root}/tmp/files/#{extracted_filename}"
      end

      def gunzip(ctx, file_path:, extname:, extracted_file:, **)
        _stdout, stderr, status = ::Open3.capture3 "gunzip -S #{extname} -c #{file_path} > #{extracted_file}"
        ctx[:gzip_stderr] = stderr
        status.success?
      end

      def log_gunzip_failed(ctx, gzip_stderr:, **)
        ctx[:error] = gzip_stderr
      end
    end
  end
end
