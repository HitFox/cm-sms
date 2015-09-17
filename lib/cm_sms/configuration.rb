module CmSms
  class Configuration
    class ProductTokenMissing < ArgumentError; end
    class EndpointMissing < ArgumentError; end
    class PathMissing < ArgumentError; end
    
    ENDPOINT = 'https://sgw01.cm.nl'
    PATH     = '/gateway.ashx'
    DCS      = 8
    
    attr_accessor :from, :to, :product_token, :endpoint, :path
    
    alias :'api_key=' :'product_token='  
    
    def endpoint
      @endpoint || ENDPOINT
    end
    
    def path
      @path || PATH
    end
    
    def defaults
      @defaults ||= { from: from, to: to }
    end
  end
end