require 'digest'
require 'net/http'

class SwitchServer < SireneAsAPIInteractor
  config.switch_server = config_for(:switch_server)

  AK = Rails.application.secrets.OVH_APPLICATION_KEY
  AS = Rails.application.secrets.OVH_APPLICATION_SECRET
  CK = Rails.application.secrets.OVH_CONSUMER_KEY
  # Timestamp as a constant since we need the same on request and signature
  TSTAMP = Time.now.to_i.to_s

  around do |interactor|
    stdout_info_log 'Starting server switch...'
    interactor.call
  end

  def call
    method = 'POST'
    adress = switch_server_request_adress

    make_ovh_api_call(method, adress, body, timestamp)
  end

  private

  def make_ovh_api_call(method, adress, body)
    uri = URI(adress)
    req = Net::HTTP::Get.new(uri)
    req['X-Ovh-Application'] = AK
    req['X-Ovh-Timestamp'] = TSTAMP
    req['X-Ovh-Signature'] = signature(method, query, body)
    req['X-Ovh-Consumer'] = CK

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
  end

  def switch_server_request_adress(ip_fallback)
    "/ip/#{ip_fallback}/move"
  end

  def timestamp
    Time.now.to_i.to_s
  end

  def signature(method, query, body)
    '$1$' + Digest::SHA1.hexdigest(AS + '+' + CK + '+' + method + '+' + query + '+' + body + '+' + TSTAMP)
  end

  def ip_fallback
    Rails.configuration.switch_server['ip_fallback']
  end

  def ovh_domain
    'https://eu.api.ovh.com/1.0'
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
