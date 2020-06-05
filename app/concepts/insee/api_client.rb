class INSEE::ApiClient
  include ActiveModel::Model
  attr_accessor :daily_update, :cursor, :token

  extend Forwardable
  def_delegators :@daily_update, :from, :to, :related_model, :insee_resource_suffix, :update_type

  # value limited by INSEE
  MAX_ELEMENTS_PER_CALL = 1_000
  # 2019-06-01T00:00:00
  TIME_FORMAT = '%Y-%m-%dT%H:%M:%S'.freeze

  def call
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    get = Net::HTTP::Get.new(url)
    get['authorization'] = "Bearer #{token}"

    http.request(get)
  end

  private

  def base_url
    'https://api.insee.fr/entreprises/sirene/V3/'
  end

  def url
    @url ||= build_url
  end

  def build_url
    uri = URI(base_url + insee_resource_suffix)
    uri.query = URI.encode_www_form(query_hash)
    uri
  end

  def query_hash
    query = {
      nombre: MAX_ELEMENTS_PER_CALL,
      curseur: cursor
    }

    query[:q] = query_filter unless update_type == 'full'
    query
  end

  def query_filter
    from_s = from.strftime TIME_FORMAT
    to_s   = to.strftime TIME_FORMAT

    "dateDernierTraitement#{related_model.name}:[#{from_s} TO #{to_s}]"
  end
end
