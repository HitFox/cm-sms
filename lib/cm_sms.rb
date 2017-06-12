require 'cm_sms/configuration'

module CmSms
  autoload :Messenger, 'cm_sms/messenger'
  autoload :Message, 'cm_sms/message'
  autoload :MessageDelivery, 'cm_sms/message_delivery'
  autoload :Webhook, 'cm_sms/webhook'

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
