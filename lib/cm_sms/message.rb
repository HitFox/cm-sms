require 'builder'
require 'phony'
require 'cm_sms/request'

module CmSms
  class Message
    class FromMissing < ArgumentError; end
    class ToMissing < ArgumentError; end
    class BodyMissing < ArgumentError; end
    class ToUnplausible < ArgumentError; end
    
    attr_accessor :from, :to, :body, :dcs, :reference
    
    def initialize(attributes = {})
      @from          = attributes[:from]
      @to            = attributes[:to]
      @dcs           = attributes[:dcs]
      @body          = attributes[:body]
      @reference     = attributes[:reference]
      
      @product_token = CmSms.config.product_token
    end
    
    def receiver_plausible?      
      receiver_present? && Phony.plausible?(to)
    end
    
    def receiver_present?
      !to.nil? && !to.empty?
    end
    
    def sender_present?
      !from.nil? && !from.empty?
    end
    
    def body_present?
      !body.nil? && !body.empty?
    end
    
    def product_token_present?
      !@product_token.nil? && !@product_token.empty?
    end
    
    def request
      Request.new(to_xml)
    end
    
    def deliver
      raise CmSms::Configuration::ProductTokenMissing.new("Please provide an valid product key.\nAfter signup at https://www.cmtelecom.de/, you will find one in your settings.") unless product_token_present?
      
      request.perform
    end
    
    def deliver!
      raise FromMissing.new('The from attribute is missing.') unless sender_present?
      raise ToMissing.new('The to attribute is missing.') unless receiver_present?
      raise BodyMissing.new('The body of the message is missing.') unless body_present?
      raise ToUnplausible.new("THe given to attribute is not a plausible phone number.\nMaybe the country code is missing.") unless receiver_plausible?
      
      deliver
    end
    
    def to_xml
      builder = Builder::XmlMarkup.new
      builder.instruct! :xml, version: '1.0'

      xml = builder.MESSAGES do |m|
        m.AUTHENTICATION do |authentication|
          authentication.PRODUCTTOKEN @product_token
        end
        m.MSG do |msg|
          msg.FROM from
          msg.TO to
          msg.DCS dcs if dcs
          msg.BODY body
          msg.REFERENCE reference if reference
        end
      end
    end
  end
end