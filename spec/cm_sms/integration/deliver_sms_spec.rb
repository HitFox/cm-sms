require 'spec_helper'
require 'webmock/rspec'

RSpec.describe 'deliver sms' do  
  
  before do
    CmSms.configure do |config|
      config.product_token = 'SOMETOKEN'
      config.endpoint = 'http://test.host'
      config.path = '/example'
    end
    
    class NotificationMessenger < CmSms::Messenger
      def notification
        content from: 'Sender Inc.', to: '+41 44 111 22 33', body: 'lorem ipsum', reference: 'Ref:123'
      end
    end
    
    stub_request(:post, "http://test.host/example").
      with(
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?><MESSAGES><AUTHENTICATION><PRODUCTTOKEN>SOMETOKEN</PRODUCTTOKEN></AUTHENTICATION><MSG><FROM>Sender Inc.</FROM><TO>+41 44 111 22 33</TO><BODY>lorem ipsum</BODY><REFERENCE>Ref:123</REFERENCE></MSG></MESSAGES>", 
        headers: { 'Content-Type' => 'application/xml' }).
      to_return(status: 200, body: "", headers: {})
  end
  
  subject do
    NotificationMessenger.notification.deliver_now!
  end
  
  it { expect(subject.success?).to be true }
  
end