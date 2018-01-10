require 'net/http'

class SolrRequests < SireneAsAPIInteractor
  attr_accessor :keyword

  def initialize *keyword
    @keyword = keyword[0].to_s
  end

  def get_suggestion
    http_session = Net::HTTP.new('localhost', solr_port)
    solr_response = http_session.get(uri_solr)
    puts 'DEBUG :' + uri_solr
    extract_suggestions(solr_response.body)
  end

  def build_dictionary
    stdout_info_log 'Building suggester dictionary..'
    begin
      request_build_dictionary
    rescue StandardError => error
      stdout_warning_log "Error while building dictionary : #{error}"
    else
      stdout_success_log('Dictionary was correctly built.')
    end
  end

  private

  def uri_solr
    "/solr/#{Rails.env}/suggesthandler?wt=json&suggest.q=#{@keyword}"
  end

  def extract_suggestions(solr_response_body)
    return if solr_response_body.empty?

    suggestions = []
    solr_response_hash = JSON.parse(solr_response_body)

    solr_response_hash['suggest']['suggest'][@keyword]['suggestions'].each do |hash|
      suggestions << hash['term']
    end
    suggestions
  end

  def request_build_dictionary
    http_session = Net::HTTP.new('localhost', solr_port)
    uri = "/solr/#{Rails.env}/suggesthandler?suggest.build=true"
    http_session.get(uri)
    return
  end

  def solr_port
    sunspot_config = YAML.load_file('config/sunspot.yml')
    sunspot_config[Rails.env]['solr']['port']
  end
end
