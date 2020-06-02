require 'builder'
require 'cm_sms/request'

module CmSms
  class Message
    class FromTooLong < ArgumentError; end
    class FromMissing < ArgumentError; end
    class ToMissing < ArgumentError; end
    class BodyMissing < ArgumentError; end
    class BodyTooLong < ArgumentError; end
    class ToUnplausible < ArgumentError; end
    class DCSNotNumeric < ArgumentError; end

    attr_accessor :from, :to, :body, :dcs, :reference
    attr_reader :product_token, :endpoints

    def initialize(attributes = {})
      @from          = attributes[:from]
      @to            = attributes[:to]
      @dcs           = attributes[:dcs]
      @body          = attributes[:body]
      @reference     = attributes[:reference]

      self.product_token = attributes[:product_token]
      self.endpoints     = attributes[:endpoints]
    end

    def product_token=(value)
      @product_token = value || CmSms.config.product_token
    end

    def endpoints=(value)
      @endpoints = value ? Array(value) : CmSms.config.endpoints
    end

    def dcs_numeric?
      true if dcs.nil? || Float(dcs)
    rescue
      false
    end

    def receiver_plausible?
      plausible = receiver_present?
      if defined?(Phony) && Phony.respond_to?(:plausible?)
        plausible &&= Phony.plausible?(to)
      elsif defined?(Phonelib) && Phonelib.respond_to?(:valid?)
        plausible &&= Phonelib.valid?(to)
      end
      plausible
    end

    def receiver_present?
      !to.nil? && !to.empty?
    end

    def sender_present?
      !from.nil? && !from.empty?
    end

    def sender_length?
      sender_present? && from.length <= 11
    end

    def body_present?
      !body.nil? && !body.empty?
    end

    def body_correct_length?
      body_present? && body.length <= 160
    end

    def product_token_present?
      !@product_token.nil? && !@product_token.empty?
    end

    def request
      Request.new(to_xml, @endpoints)
    end

    def deliver
      raise CmSms::Configuration::ProductTokenMissing, "Please provide an valid product key.\nAfter signup at https://www.cmtelecom.de/, you will find one in your settings." unless product_token_present?

      request.perform
    end

    def deliver!
      raise FromMissing, 'The value for the from attribute is missing.' unless sender_present?
      raise FromTooLong, 'The value for the sender attribute must contain 1..11 characters.' unless sender_length?
      raise ToMissing, 'The value for the to attribute is missing.' unless receiver_present?
      raise BodyMissing, 'The body of the message is missing.' unless body_present?
      raise BodyTooLong, 'The body of the message has a length greater than 160.' unless body_correct_length?
      raise ToUnplausible, "The given value for the to attribute is not a plausible phone number.\nMaybe the country code is missing." unless receiver_plausible?
      raise DCSNotNumeric, 'The given value for the dcs attribute is not a number.' unless dcs_numeric?

      deliver
    end

    def to_xml
      builder = Builder::XmlMarkup.new
      builder.instruct! :xml, version: '1.0'
      builder.MESSAGES do |m|
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
