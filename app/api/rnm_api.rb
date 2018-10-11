require 'net/http'
require 'openssl'

class RnmAPI < SireneAsAPIInteractor
  def initialize(siren)
    @query = path_siren_request + siren
  end

  def call
    response = send_request

    response.body
  end

  def send_request
    uri = URI.parse(rnm_domain)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    http.request(request)
  end

  def request
    request = Net::HTTP::Get.new(@query)
    request.add_field('Content-Type', 'application/json')
    request
  end

  def path_siren_request
    '/api/Entreprise/'
  end

  def rnm_domain
    'https://api-rnm.artisanat.fr'
  end
end
