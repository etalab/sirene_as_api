module INSEE
  module Operation
    class RenewToken < Trailblazer::Operation
      step :file_exist?
      step :load_file
      step :verify_expiration
      step :log_token_still_valid, Output(:success) => 'End.success'
      fail Nested(INSEE::Request::RenewToken), Output(:success) => Track(:success)
      step :persist_secrets

      def file_exist?(_, **)
        File.exist?(filename)
      end

      def load_file(ctx, **)
        current_secrets = YAML.load_file(filename).symbolize_keys
        ctx[:token] = current_secrets[:token]
        ctx[:expiration_date] = current_secrets[:expiration_date]
      end

      def verify_expiration(_, expiration_date:, **)
        expiration_date > Time.zone.now.to_i
      end

      def persist_secrets(ctx, **)
        File.write(filename, secrets(ctx).to_yaml)
      end

      def log_token_still_valid(_, expiration_date:, logger:, **)
        logger.info "Token still valid until #{Time.at(expiration_date)}"
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
