module CmSms
  class Request
    attr_accessor :body
    
    attr_reader :response
    
    def initialize(body)
      @body = body
      @endpoint = CmSms.config.endpoint
      @path = CmSms.config.path
    end
    
    def perform      
      raise Configuration::EndpointMissing.new("Please provide an valid api endpoint.\nIf you leave this config blank, the default will be set to https://sgw01.cm.nl.") if @endpoint.blank?
      raise Configuration::PathMissing.new("Please provide an valid api path.\nIf you leave this config blank, the default will be set to /gateway.ashx.") if @endpoint.blank?

      uri = URI.parse(@endpoint)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        @response = Response.new(http.post(@path, body, initheader = { 'Content-Type' => 'application/xml' }))
      end
      response
    end
  end
end