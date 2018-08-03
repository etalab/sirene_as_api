require 'json'

class CheckCurrentService < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log 'Checking which server is currently running the API...'

    interactor.call

    stdout_success_log 'Other machine is currently in use. Update will start.'
  end

  def call
    method = 'GET'
    query = check_current_service_query
    body = ''

    response = OvhAPICall.new(method, query, body).call

    other_machine_in_use?(response)
  end

  private

  def check_current_service_query
    "/ip/#{ip_fallback}/"
  end

  def ip_fallback
    Rails.configuration.switch_server['ip_fallback']
  end

  def other_machine_in_use?(response)
    current_service = get_current_service(response)

    # It is safer to check if other machine is in use, not if our machine is in use.
    if current_service == sibling_machine_name
      context.success!
    else
      stdout_error_log "Other machine doesn't seem in use now. Can't start update"
      context.fail!
    end
  end

  def current_machine_name
    File.open('/etc/hosts') do |file|
      file.to_a.last.split(' ')[1]
    end
  end

  def sibling_machine_name
    machines = [Rails.configuration.switch_server['sirene_server1'],
                Rails.configuration.switch_server['sirene_server2']]
    machines.delete(current_machine_name)
    machines[0]
  end

  def get_current_service(response)
    service_description = JSON.parse(response.body)
    service_description['routedTo']['serviceName']
  end
end
