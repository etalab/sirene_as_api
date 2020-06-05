require 'net/http'
require 'uri'
require 'json'

class SolrRequests < SireneAsAPIInteractor
  attr_accessor :keyword

  def initialize(*keywords)
    keyword = keywords[0].to_s.gsub(/[+<>'"=&,;\n]/, ' ') # Get first word in params & Prevent Solr injections
    @keyword = URI.encode_www_form_component(keyword)
  end

  def request_suggestions
    http_session = Net::HTTP.new('localhost', solr_port)
    http_session.get(uri_solr)
  end

  def build_dictionary
    stdout_info_log 'Building suggester dictionary... This might take a while (~30 mins)'
    begin
      request_build_dictionary
    rescue StandardError => e
      stdout_error_log "Error while building dictionary : #{e}"
    else
      stdout_success_log('Dictionary was correctly built !')
    end
  end

  private

  def uri_solr
    "#{solr_base_url}/suggesthandler?wt=json&suggest.q=#{@keyword}"
  end

  def request_build_dictionary
    http_session = Net::HTTP.new('localhost', solr_port)
    http_session.read_timeout = 14_400 # 4 hours max to build dictionary
    uri = "#{solr_base_url}/suggesthandler?suggest.build=true"
    http_session.get(uri)
  end

  def solr_port
    solr_conf['port']
  end

  def solr_base_url
    solr_conf['path']
  end

  def solr_conf
    Rails.application.config_for(:sunspot)['solr']
  end
end
