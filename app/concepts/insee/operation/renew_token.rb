module INSEE
  module Operation
    class RenewToken < Trailblazer::Operation
      step :file_exist?
      step :load_file
      step :verify_expiration
      failure :renew_token, Output(:success) => Track(:success)
      step :secrets!

      def file_exist?(_, **)
        File.exist?(filename)
      end

      def load_file(ctx, **)
        ctx[:insee_secrets] = YAML.load_file(filename)
      end

      def verify_expiration(_, insee_secrets:, **)
        expiration_date = Time.zone.at(insee_secrets['expiration_date'])
        expiration_date > Time.zone.now
      end

      def renew_token(ctx, **)
        ctx[:insee_secrets] = insee_secrets.as_json
        File.write(filename, ctx[:insee_secrets].to_yaml)
      end

      def secrets!(ctx, insee_secrets:, **)
        ctx[:insee_token] = insee_secrets['token']
        ctx[:insee_expiration_date] = insee_secrets['expiration_date']
      end

      private

      def insee_secrets
        {
          token: request[:token],
          expiration_date: request[:expiration_date]
        }
      end

      def request
        @request ||= INSEE::Request::RenewToken.call
      end

      def filename
        Rails.root.join('config', 'insee_secrets.yml')
      end
    end
  end
end
