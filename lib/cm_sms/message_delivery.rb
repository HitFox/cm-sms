require 'delegate'

module CmSms
  class MessageDelivery < Delegator
    def initialize(messenger, message_method, *args) #:nodoc:
      @messenger      = messenger
      @message_method = message_method
      @args           = args
    end

    def __getobj__ #:nodoc:
      @obj ||= @messenger.send(:new).send(@message_method, *@args).message
    end
    
    alias :message :__getobj__

    def __setobj__(obj) #:nodoc:
      @obj = obj
    end

    def deliver_now!
      message.deliver!
    end

    def deliver_now
      message.deliver
    end
    
    def inspect
      prefix = "#<#{self.class}:0x#{self.__id__.to_s(16)}"
      parts  = instance_variables.map { |var| "#{var}=#{instance_variable_get(var).inspect}" }
      str    = [prefix, parts, ']>'].join(' ')

      str.taint if tainted?
      str
    end
  end
end
