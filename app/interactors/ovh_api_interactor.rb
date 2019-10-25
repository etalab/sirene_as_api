class OvhAPIInteractor < SireneAsAPIInteractor
  def initialize(method, query, body = '')
    @method = method
    @query = query
    @body = body
  end

  def call
    response = OvhRequest.new(@method, @query, @body).send

    stdout_error_log 'Error: Call to API failed' && context.fail! unless response.is_a? Net::HTTPSuccess
  end
end
