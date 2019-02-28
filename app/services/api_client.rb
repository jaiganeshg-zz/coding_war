class ApiClient

  DEFAULT_CONNECTION_TIMEOUT = 30

  class Error < StandardError
    attr_reader :response

    def initialize(message, response=nil)
      super(message)
      @response = response
    end

    def bad_request?
      self.message == '400'
    end

    def http_code
      self.message
    end
  end

  DEFAULT_HEADERS = { 'Content-Type' => 'application/json' }

  private

  def log_request(url, headers = {}, body = {})
    Rails.logger.warn "Call:\nURL: #{url}\nHeaders: #{headers}\nBody: #{body} at: #{DateTime.now}"
  end

  def api_call(method, url, params, return_response, return_header = false)
    @http_client = HTTPClient.new
    @http_client.connect_timeout = DEFAULT_CONNECTION_TIMEOUT
    @http_client.ssl_config.ssl_version = 'TLSv1_2'
    log_request(url, params[:header], params[:body])
    response = @http_client.request(method, url, params)
    return_header ? parse_response_with_headers(response) : parse_response(response, return_response)
  end

  def parse_response(response, return_response = false)
    Rails.logger.warn "response with body #{response.body} received at: #{DateTime.now}"
    if response.status == 200 || response.status == 201
      begin
        response_object = indifferent_access(JSON.parse(response.body))
      rescue JSON::ParserError, NoMethodError
        response_object = { body: response.body, status: response.status }
      end
      return_response ? response_object : true
    else
      Rails.logger.error "status: #{response.status}, message: #{response.headers["Error-Message"] || response.body}"
      raise self.class::Error.new("status: #{response.status}, message: #{response.headers["Error-Message"] || response.body}")
    end
  end

  def parse_response_with_headers(response)
    Rails.logger.warn "response with body #{response.body} received at: #{DateTime.now}"
    if response.status == 200 || response.status == 201
      begin
        response = { body: indifferent_access(JSON.parse(response.body)), header: response.headers }
      rescue JSON::ParserError, NoMethodError
        response = { body: response.body, header: response.headers }
      end
      response
    else
      Rails.logger.error "status: #{response.status}, error: #{response.headers['Error-Message']}"
      raise self.class::Error.new("#{response.status}, #{response.headers["Error-Message"]}")
    end
  end

  def indifferent_access(obj)
    if obj.is_a? Array
      obj.map(&:with_indifferent_access)
    else
      obj.with_indifferent_access
    end
  end
end
