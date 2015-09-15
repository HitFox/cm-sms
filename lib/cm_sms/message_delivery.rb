require 'delegate'

module CmSms
  class MessageDelivery < Delegator
    def initialize(messenger, message_method, *args) #:nodoc:
      @messenger = messenger
      @message_method = message_method
      @args = args
    end

    def __getobj__ #:nodoc:
      @obj ||= @messenger.send(:new).send(@message_method, *@args).message
    end

    def __setobj__(obj) #:nodoc:
      @obj = obj
    end

    # Returns the Mail::Message object
    def message
      __getobj__
    end

    def deliver_later!(options={})
      enqueue_delivery :deliver_now!, options
    end

    def deliver_later(options={})
      enqueue_delivery :deliver_now, options
    end

    def deliver_now!
      message.deliver!
    end

    def deliver_now
      message.deliver
    end
    
    def inspect
      prefix = "#<#{self.class}:0x#{self.__id__.to_s(16)}"
      parts = instance_variables.map { |var| "#{var}=#{instance_variable_get(var).inspect}" }
      str = [prefix, parts, ']>'].join(' ')

      str.taint if tainted?
      str
    end

    private

    def enqueue_delivery(delivery_method, options = {})
      raise 'Please use the deliver_now method, because you not have ActiveJob setted up right.' unless defined?(ActiveJob)
      
      args = @messenger.name, @message_method.to_s, delivery_method.to_s, *@args
      CmSms::DeliveryJob.set(options).perform_later(*args)
    end
  end
end
