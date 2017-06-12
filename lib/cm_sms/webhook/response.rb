module CmSms
  module Webhook
    class Response
      ATTRIBUTE_NAMES = %w[created_s datetime_s gsm reference standarderrortext status
                           statusdescription externalstatusdescription id operator recipient srcreated gsm
                           srcreated_s statuscodestring statusissuccess time errorcode].freeze

      attr_reader :attributes, *ATTRIBUTE_NAMES

      def initialize(attributes = {})
        @attributes = attributes

        attributes.each { |attr, value| instance_variable_set("@#{attr.downcase}", value) } if attributes
      end

      def statusissuccess?
        !statusissuccess.to_s.strip.empty?
      end

      def datetime_s?
        !datetime_s.to_s.strip.empty?
      end

      def status?
        !status.to_s.strip.empty?
      end

      def errorcode?
        !errorcode.to_s.strip.empty?
      end

      def received_at
        Time.parse(datetime_s) if datetime_s?
      end

      def accepted?
        status? && status.to_s == '0'
      end

      def rejected?
        status? && status.to_s == '1'
      end

      def delivered?
        status? && status.to_s == '2'
      end

      def failed?
        status? && status.to_s == '3'
      end

      def error?
        errorcode? || rejected? || failed?
      end

      def success?
        statusissuccess? && statusissuccess.to_s.strip == '1'
      end

      def to_yaml
        (@attributes || {}).to_yaml
      end
    end
  end
end
