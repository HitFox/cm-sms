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
    
    def load_messengers!
      Dir[Rails.root.join('app','messengers', '*.rb')].each { |file| require(file) } if defined?(Rails)
    end
  end
end

CmSms.load_messengers!



