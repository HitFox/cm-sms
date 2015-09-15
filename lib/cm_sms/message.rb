require 'builder'
require 'phony'

module CmSms
  class Message
    class FromMissing < ArgumentError; end
    class ToMissing < ArgumentError; end
    class BodyMissing < ArgumentError; end
    class ToUnplausible < ArgumentError; end
    
    attr_accessor :from, :to, :body, :dcs, :reference
    
    def initialize(attributes = {})
      @from = attributes[:from]
      @to = attributes[:to]
      @dcs = attributes[:dcs]
      @body = attributes[:body]
      @reference = attributes[:reference]
      @product_token = CmSms.config.product_token
    end
    
    def to_plausible?
      to_present? && Phony.plausible?(to)
    end
    
    def to_present?
      !to.nil? && !to.empty?
    end
    
    def from_present?
      !from.nil? && !from.empty?
    end
    
    def body_present?
      !body.nil? && !body.empty?
    end
    
    def deliver
      raise Configuration::ProductTokenMissing.new("Please provide an valid product key.\nAfter signup at https://www.cmtelecom.de/, you will find one in your settings.") if @product_token.blank?
      
      Request.new(to_xml).perform
    end
    
    def deliver!
      raise FromMissing.new('The from attribute is missing.') unless from_present?
      raise ToMissing.new('The to attribute is missing.') unless to_present?
      raise BodyMissing.new('The body of the message is missing.') unless body_present?
      raise ToUnplausible.new("THe given to attribute is not a plausible phone number.\nMaybe the country code is missing.")
      
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