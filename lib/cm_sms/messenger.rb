module CmSms
  class Messenger
    attr_accessor :from, :to, :body, :dcs, :reference

    def initialize(attributes = {})
      self.class.default_params ||= {}
      @from = attributes[:from] || self.class.default_params[:from]
      @to   = attributes[:to] || self.class.default_params[:to]
      @dcs  = attributes[:dcs] || self.class.default_params[:dcs]
      @body = attributes[:body]
      @reference = attributes[:reference]
    end

    def content(attributes = {})
      attributes.each { |attr, value| send("#{attr}=", value) }
      self
    end

    def message
      @message ||= CmSms::Message.new(from: from, to: to, dcs: dcs, body: body, reference: reference)
    end

    class << self
      def method_missing(method_name, *args) # :nodoc:
        if new.respond_to?(method_name.to_s)
          CmSms::MessageDelivery.new(self, method_name, *args)
        else
          super
        end
      end

      def respond_to_missing?(method_name, *args) # :nodoc:
        new.respond_to?(method_name.to_s) || super
      end

      def default_params
        @default_params ||= CmSms.config.defaults
      end

      def default_params=(params = {})
        @default_params = params || {}
      end

      def default(hash = {})
        self.default_params = CmSms.config.defaults.merge(hash).freeze
      end
    end
  end
end
