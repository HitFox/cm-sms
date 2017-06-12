module CmSms
  class Response
    attr_reader :net_http_response, :body, :code

    def initialize(net_http_response)
      @net_http_response = net_http_response
      @body              = @net_http_response.body
      @code              = @net_http_response.code
    end

    def success?
      body.to_s.strip.empty? && code.to_i == 200
    end

    def failure?
      !success?
    end

    def error
      body.sub('Error: ERROR', '').strip
    end
  end
end
