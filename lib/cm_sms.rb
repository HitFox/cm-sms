require 'cm_sms/configuration'

module CmSms
  autoload :Messenger, 'cm_sms/messenger'
  autoload :Message, 'cm_sms/message'
  autoload :MessageDelivery, 'cm_sms/message_delivery'
  autoload :DeliveryJob, 'cm_sms/delivery_job' if defined?(ActiveJob)
  
  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
    
    alias :config :configuration
  end
end



