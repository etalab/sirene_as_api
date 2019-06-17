require 'net/http'
require 'uri'
require 'json'

module Solr::Suggestions
  class Index < Trailblazer::Operation
    pass :log_begin
    step :request_build
    pass :log_completed

    def request_build(_, **)
      http = Net::HTTP.new('localhost', solr_port)
      http.read_timeout = 11_000 # 3 hour max to build dictionary
      http.get(path_build_request)
    end

    def log_begin(_, logger:, **)
      logger.info 'Starting dictionary build (30-120 mins)...'
    end

    def log_completed(_, logger:, **)
      logger.info 'Finished building dictionary'
    end

    private

    def path_build_request
      "/solr/#{Rails.env}/suggesthandler?suggest.build=true"
    end

    def solr_port
      Rails.application.config_for('sunspot')['solr']['port']
    end
  end
end
