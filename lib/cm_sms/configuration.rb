module CmSms
  class Configuration
    class ProductTokenMissing < ArgumentError; end
    class EndpointMissing < ArgumentError; end
    class PathMissing < ArgumentError; end

    ENDPOINTS = %w[https://sgw01.cm.nl https://sgw02.cm.nl].map(&:freeze).freeze
    PATH = '/gateway.ashx'.freeze
    DCS = 0
    TIMEOUT = 10

    attr_accessor :from, :to, :product_token
    attr_writer :endpoints, :path, :dcs, :timeout

    alias api_key= product_token=
    alias endpoint= endpoints=

    def endpoints
      endpoints = Array(@endpoints)
      endpoints.empty? ? ENDPOINTS : endpoints
    end

    def path
      @path || PATH
    end

    def dcs
      @dcs || DCS
    end

    def timeout
      @timeout || TIMEOUT
    end

    def defaults
      @defaults ||= { from: from, to: to, dcs: dcs }
    end
  end
end
