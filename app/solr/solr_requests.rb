require 'net/http'
require 'uri'

class SolrRequests < SireneAsAPIInteractor
  attr_accessor :keyword

  def initialize *keywords
    keyword = keywords[0].to_s.gsub(/[+<>=&,;\n]/, ' ') # Get first word in params & Prevent Solr injections
    @keyword = URI.decode(keyword)
  end

  def get_suggestions
    http_session = Net::HTTP.new('localhost', solr_port)
    solr_response = http_session.get(uri_solr)
    extract_suggestions(solr_response.body)
  end

  def build_dictionary
    stdout_info_log 'Building suggester dictionary... This might take a while (~30 mins)'
    begin
      request_build_dictionary
    rescue StandardError => error
      stdout_warn_log "Error while building dictionary : #{error}"
    else
      stdout_success_log('Dictionary was correctly built !')
    end
  end

  private

  def uri_solr
    uri = "/solr/#{Rails.env}/suggesthandler?wt=json&suggest.q=#{@keyword}"
    URI.encode(uri)
  end

  def extract_suggestions(solr_response_body)
    suggestions = []
    solr_response_hash = JSON.parse(solr_response_body)

    solr_response_hash['suggest']['suggest'][@keyword]['suggestions'].each do |hash|
      suggestions << hash['term']
    end
    suggestions
  end

  def request_build_dictionary
    http_session = Net::HTTP.new('localhost', solr_port)
    http_session.read_timeout = 3600 # 1 hour max to build dictionary
    uri = "/solr/#{Rails.env}/suggesthandler?suggest.build=true"
    http_session.get(uri)
    return
  end

  def solr_port
    sunspot_config = YAML.load_file('config/sunspot.yml')
    sunspot_config[Rails.env]['solr']['port']
  end
end
