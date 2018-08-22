require 'cm_sms/response'

module CmSms
  class Request
    attr_accessor :body

    attr_reader :response

    def initialize(body, endpoints = nil)
      @body     = body
      @endpoint = (endpoints || CmSms.config.endpoints).sample
      @path     = CmSms.config.path
    end

    def perform
      raise CmSms::Configuration::EndpointMissing, 'Please provide an valid api endpoint.' if @endpoint.nil? || @endpoint.empty?
      raise CmSms::Configuration::PathMissing, "Please provide an valid api path.\nIf you leave this config blank, the default will be set to /gateway.ashx." if @path.nil? || @path.empty?

      uri = URI.parse(@endpoint)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        @response = Response.new(http.post(@path, body, 'Content-Type' => 'application/xml'))
      end
      response
    end
  end
end
