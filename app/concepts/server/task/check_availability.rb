class Server
  module Task
    class CheckAvailability < Trailblazer::Operation
      step :call_host_api
      fail :log_call_error
      step :service_name
      step :machines_names
      step :check_current_availability
      fail :log_machine_unavailable
      step :log_machine_available

      def call_host_api(ctx, **)
        response = OvhRequest.new('GET', "/ip/#{ip_fallback}/").send_request
        return false unless response.is_a? Net::HTTPSuccess

        ctx[:response] = response
      end

      def log_call_error(_, logger:, **)
        logger.error "Request to host API failed, can't fetch current service"
      end

      def service_name(ctx, response:, **)
        service = JSON.parse(response.body)
        ctx[:service] = service['routedTo']['serviceName']
      end

      def machines_names(ctx, **)
        ctx[:current] = current_machine_name

        ctx[:sibling] = sibling_machine_name
      end

      # Current server available if other server in use
      def check_current_availability(_, service:, sibling:, **)
        return false if service.nil?

        service == sibling
      end

      def log_machine_unavailable(_, logger:, **)
        logger.warn 'Current machine in use, not available for update.'
      end

      def log_machine_available(_, logger:, **)
        logger.info 'Current machine not in use, available for update.'
      end

      def current_machine_name
        File.open('/etc/hosts') { |f| f.to_a.last.split(' ')[1] }
      end

      def sibling_machine_name
        both = [Rails.configuration.switch_server['sirene_server1'],
                Rails.configuration.switch_server['sirene_server2']]

        both.delete(current_machine_name)
        both.first
      end

      def ip_fallback
        Rails.configuration.switch_server['ip_fallback']
      end
    end
  end
end
