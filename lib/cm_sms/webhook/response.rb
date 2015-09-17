module CmSms
  module Webhook
    class Response

      ATTRIBUTE_NAMES = %w(sent received to reference statuscode errorcode errordescription)
      
      attr_reader *ATTRIBUTE_NAMES
      
      def initialize(attributes = {})
        attributes.each { |attr, value| instance_variable_set("@#{attr}", value) } if attributes
      end
      
      def sent?
        !sent.to_s.strip.empty?
      end
      
      def received?
        !received.to_s.strip.empty?
      end
      
      def statuscode?
        !statuscode.to_s.strip.empty?
      end
      
      def errorcode?
        !errorcode.to_s.strip.empty?
      end
      
      def sent_at
        Time.parse(sent) if sent?
      end
      
      def received_at
        Time.parse(received) if received?
      end
      
      def accepted?
        statuscode? && statuscode.to_s == '0'
      end
      
      def rejected?
        statuscode? && statuscode.to_s == '1'
      end
      
      def delivered?
        statuscode? && statuscode.to_s == '2'
      end
      
      def failed?
        statuscode? && statuscode.to_s == '3'
      end
      
      def error?
        errorcode? || rejected? || failed?
      end

    end
  end
end