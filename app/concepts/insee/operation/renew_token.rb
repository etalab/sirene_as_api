module INSEE
  module Operation
    class RenewToken < Trailblazer::Operation
      step :file_exist?
      step :load_file
      step :verify_expiration
      failure Nested(INSEE::Request::RenewToken), Output(:success) => Track(:token_renewed)
      step :persist_secrets, magnetic_to: [:token_renewed]

      def file_exist?(_, **)
        File.exist?(filename)
      end

      def load_file(ctx, **)
        current_secrets = YAML.load_file(filename)
        ctx[:token] = current_secrets['token']
        ctx[:expiration_date] = current_secrets['expiration_date']
      end

      def verify_expiration(_, expiration_date:, **)
        expiration_date > Time.zone.now.to_i
      end

      def persist_secrets(ctx, **)
        File.write(filename, secrets(ctx).to_yaml)
      end

      private

      def secrets(ctx)
        {
          token: ctx[:token],
          expiration_date: ctx[:expiration_date]
        }
      end

      def filename
        Rails.root.join('config', 'insee_secrets.yml')
      end
    end
  end
end
