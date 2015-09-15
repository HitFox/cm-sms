module CmSms
  class Response
    attr_reader :net_http_response, :body
    
    def initialize(net_http_response)
      @net_http_response = net_http_response
      @body              = @net_http_response.body
    end
    
    def success?
      body.empty?
    end
    
    def failure?
      !success?
    end
    
    def error
      body.slice('Error: ERROR')
    end
  end
end