module CmSms
  class DeliveryJob < ActiveJob::Base
    class Error < StandardError; end
    
    queue_as :cm_messengers

    def perform(messenger, message_method, delivery_method, *args) # :nodoc:
      messenger.constantize.public_send(message_method, *args).send(delivery_method)
    end
  end
end