require 'json'

class SwitchServer < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log 'Starting server switch...'
    interactor.call
    stdout_success_log 'Successfully made switch request !'
  end

  def call
    method = 'POST'
    query = switch_server_query
    body = { to: current_machine_verified }.to_json

    OvhAPI.new(method, query, body).call
  end

  private

  def switch_server_query
    "/ip/#{ip_fallback}/move"
  end

  def ip_fallback
    Rails.configuration.switch_server['ip_fallback']
  end

  # Routing to current machine, but first a security check to see if configuration is OK
  def current_machine_verified
    sirene_server1 = Rails.configuration.switch_server['sirene_server1']
    sirene_server2 = Rails.configuration.switch_server['sirene_server2']

    if [sirene_server1, sirene_server2].include? current_machine_name
      current_machine_name
    else
      stdout_error_log 'Error during server switch: This server doesnt seem to be registered in Rails config.'
      context.fail!
    end
  end

  def current_machine_name
    File.open('/etc/hosts') do |file|
      file.to_a.last.split(' ')[1]
    end
  end
end
