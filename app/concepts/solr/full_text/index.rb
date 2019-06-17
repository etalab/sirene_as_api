require 'net/http'
require 'uri'
require 'json'

module Solr::FullText
  class Index < Trailblazer::Operation
    pass :log_begin
    step :build
    pass :log_completed

    def build(_, **)
      `RAILS_ENV=#{Rails.env} bundle exec rake sunspot:reindex`
    end

    def log_begin(_, logger:, **)
      logger.info 'Starting FullText indexing...'
    end

    def log_completed(_, logger:, **)
      logger.info 'Finished building dictionary'
    end
  end
end
