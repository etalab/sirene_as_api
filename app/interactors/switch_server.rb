require 'json'

class SwitchServer < SireneAsAPIInteractor
  config.switch_server = config_for(:switch_server)

  around do |interactor|
    stdout_info_log 'Starting server switch...'
    interactor.call
    stdout_success_log 'Successfully made switch request !'
  end

  def call
    method = 'POST'
    query = switch_server_query
    body = { to: destination_server }.to_json

    OvhAPICall.new(method, query, body).call
  end

  private

  def switch_server_query(ip_fallback)
    "/ip/#{ip_fallback}/move"
  end

  def ip_fallback
    Rails.configuration.switch_server['ip_fallback']
  end

  def destination_server
    sirene_server1 = Rails.configuration.switch_server['sirene_server1']
    sirene_server2 = Rails.configuration.switch_server['sirene_server2']

    if current_machine_name == sirene_server1
      sirene_server2
    elsif current_machine_name == sirene_server2
      sirene_server1
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
