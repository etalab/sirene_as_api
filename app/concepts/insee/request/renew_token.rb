module INSEE
  module Request
    class RenewToken < Trailblazer::Operation
      step :get
      step :parse_response

      def get(ctx, **)
        ctx[:response] = http.request(request)
      end

      def parse_response(ctx, response:, **)
        response_json = JSON.parse(response.body, symbolize_names: true)

        ctx[:token] = response_json[:access_token]
        ctx[:expires_in] = response_json[:expires_in]
        ctx[:expiration_date] = Time.zone.now.to_i + response_json[:expires_in]
      end

      private

      def http
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      end

      def request
        request = Net::HTTP::Post.new(url)
        request['authorization'] = "Basic #{token}"
        request.body = 'grant_type=client_credentials'
        request
      end

      def url
        URI('https://api.insee.fr/token')
      end

      def token
        Rails.application.config_for(:secrets)['insee_credentials']
      end
    end
  end
end
