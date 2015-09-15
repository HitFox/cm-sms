module CmSms
  class Messenger
    
    attr_accessor :from, :to, :body, :dcs
    
    def initialize(attributes = {})
      self.class.default_params ||= {}
      
      @from = attributes[:from] || self.class.default_params[:from]
      @to   = attributes[:to] || self.class.default_params[:to]
      @dcs  = attributes[:dcs] || self.class.default_params[:dcs]
      @body = attributes[:body]
    end
    
    def content(attributes = {})
      attributes.each { |attr, value| send("#{attr}=", value) }
      self
    end
    
    def message
      @message ||= CmSms::Message.new(from: from, to: to, dcs: dcs, body: body)
    end
    
    def self.method_missing(method_name, *args) # :nodoc:
      if new.respond_to?(method_name.to_s)
        CmSms::MessageDelivery.new(self, method_name, *args)
      else
        super
      end
    end
    
    def self.defaults
      @@default_params
    end

    def self.default_params=value
      @@default_params
    end
    
    def self.default(hash = {})
      self.default_params = CmSms.config.defaults.merge(hash).freeze
      default_params
    end
    
  end
end
  