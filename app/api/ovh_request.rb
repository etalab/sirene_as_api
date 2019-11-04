require 'digest'
require 'net/http'
require 'openssl'

class OvhRequest
  AK = Rails.application.secrets.OVH_APPLICATION_KEY
  AS = Rails.application.secrets.OVH_APPLICATION_SECRET
  CK = Rails.application.secrets.OVH_CONSUMER_KEY

  def initialize(method, query, body = '')
    @method = method
    @query = ovh_api_version + query
    @full_query = ovh_domain + ovh_api_version + query
    @body = body
    @tstamp = Time.now.to_i.to_s
  end

  def send_request
    uri = URI.parse(ovh_domain)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    http.request(request)
  end

  def request
    request = request_get if @method == 'GET'
    request = request_post if @method == 'POST'
    raise 'Error : method parameter should be GET or POST' unless request

    add_headers(request)
    request
  end

  def request_get
    Net::HTTP::Get.new(@query)
  end

  def request_post
    request = Net::HTTP::Post.new(@query)
    request.add_field('Content-Type', 'application/json')
    request.body = @body
    request
  end

  def add_headers(request)
    request['X-Ovh-Application'] = AK
    request['X-Ovh-Timestamp'] = @tstamp
    request['X-Ovh-Signature'] = signature
    request['X-Ovh-Consumer'] = CK
  end

  def signature
    '$1$' + Digest::SHA1.hexdigest(AS + '+' + CK + '+' + @method + '+' + @full_query + '+' + @body + '+' + @tstamp)
  end

  def ovh_domain
    'https://api.ovh.com'
  end

  def ovh_api_version
    '/1.0'
  end
end
