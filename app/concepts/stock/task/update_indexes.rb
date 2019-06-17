require 'net/http'

class Stock
  module Task
    class UpdateIndexes < Trailblazer::Operation
      step :solr_on?
        fail :log_solr_off, fail_fast: true
      step Nested Solr::Suggestions::Index
      step Nested Solr::FullText::Index
      pass :log_indexes_completed

      def solr_on?(_, **)
        Net::Ping::HTTP.new("#{solr_url}/admin/ping").ping?
      end

      def log_solr_off(_, logger:, **)
        logger.error 'Error : solr unreacheable. Make sure it is active and accessible.'
      end

      def log_indexes_completed(_, logger:, **)
        logger.info 'Finished building index and dictionary'
      end

      private

      def solr_url
        Sunspot.session.config.solr.url
      end
    end
  end
end
