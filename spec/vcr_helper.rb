VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = false
  c.ignore_localhost = true
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes, allow_playback_repeats: true, match_requests_on: %i[method uri body] }

  # Config ignore_request to stop VCR from managing Solr server requests
  c.ignore_request do |request|
    URI(request.uri).port == 8981
  end

  # VCR client's filters
  c.filter_sensitive_data('<INSEE_CREDENTIALS>') { Rails.application.config_for(:secrets)['insee_credentials'] }
end
