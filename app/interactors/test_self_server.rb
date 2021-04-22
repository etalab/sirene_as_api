require 'json'

# Best way to test if API works is to test full_text since it uses solr.
# 'Montpellier' search have ~62K results. If we find over 60K, we can assume database is correctly filled.
class TestSelfServer < SireneAsAPIInteractor
  around do |interactor|
    stdout_info_log 'Testing if current server API is up and running...'
    interactor.call
    stdout_success_log "This server's API is correctly working !"
  end

  def call
    test_results = JSON.parse(execute_test)

    return context.fail! unless test_results && test_results['total_results'] > 60_000

    context.success!
  rescue StandardError => e
    stdout_error_log "Couldn't parse API result : #{e}"
    context.fail!
  end

  private

  def execute_test
    `curl --resolve entreprise.data.gouv.fr:443:127.0.0.1 https://entreprise.data.gouv.fr/api/sirene/v1/full_text/montpellier`
  rescue StandardError => e
    stdout_error_log "Couldn't reach the API on this server : #{e}"
    context.fail!
  end
end
