require 'spec_helper'
require 'cm_sms/message'

RSpec.describe CmSms::Message do
  
  let(:message_body) { 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirood tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At v' }
  
  let(:message) do
    message = described_class.new
    message.from = 'ACME corp.'    
    message.to = '+41 44 111 22 33'      
    message.body = message_body
    message.reference = 'Ref:123'
    message
  end
  
  describe '#receiver_plausible?' do
    context 'when a valid phone number is provided' do
      it { expect(message.receiver_plausible?).to be true }
    end
    
    context 'when a invalid phone number is provided' do
      subject(:resource) do
        message.to = 'Fuubar'        
        message
      end
      it { expect(resource.receiver_plausible?).to be false }
    end
  end
  
  describe '#receiver_present?' do
    context 'when a valid phone number is provided' do
      it { expect(message.receiver_present?).to be true }
    end
    
    context 'when no phone number is provided' do
      subject(:resource) do
        message.to = nil        
        message
      end
      it { expect(resource.receiver_present?).to be false }
    end
  end
  
  describe '#sender_present?' do
    context 'when a valid from is provided' do
      it { expect(message.sender_present?).to be true }
    end
    
    context 'when no from is provided' do
      subject(:resource) do
        message.from = nil        
        message
      end
      it { expect(resource.sender_present?).to be false }
    end
  end
  
  describe '#body_present?' do
    context 'when a valid body is provided' do
      it { expect(message.body_present?).to be true }
    end
    
    context 'when no body is provided' do
      subject(:resource) do
        message.body = nil        
        message
      end
      it { expect(resource.body_present?).to be false }
    end
  end
  
  describe '#product_token_present?' do
    context 'when a valid product_token is provided' do
      before { CmSms.configure { |config| config.product_token = 'SOMETOKEN' } }
      it { expect(message.product_token_present?).to be true }
    end
    
    context 'when no product_token is provided' do
      before { CmSms.configure { |config| config.product_token = nil } }
      it { expect(message.product_token_present?).to be false }
    end
  end
  
  describe '#deliver' do
    context 'when product token is missing in configuration' do
      before { CmSms.configure { |config| config.product_token = nil } }
      it { expect { message.deliver }.to raise_error CmSms::Configuration::ProductTokenMissing }
    end
    
    context 'when all needed attributes set' do
      before do 
        CmSms.configure { |config| config.product_token = 'SOMETOKEN' }
        request = instance_double(CmSms::Request)
        allow(request).to receive(:perform).and_return(true)
        allow(message).to receive(:request).and_return(request)
      end
      it { expect(message.deliver).to be true }
    end
  end
  
  describe '#deliver!' do
    context 'when product token is missing in configuration' do
      before { CmSms.configure { |config| config.product_token = nil } }
      it { expect { message.deliver! }.to raise_error CmSms::Configuration::ProductTokenMissing }
    end
    
    context 'when receiver is missing' do
      subject(:resource) do
        message.to = nil
        message
      end
      it { expect { resource.deliver! }.to raise_error CmSms::Message::ToMissing }
    end
    
    context 'when sender is missing' do
      subject(:resource) do
        message.from = nil
        message
      end
      it { expect { resource.deliver! }.to raise_error CmSms::Message::FromMissing }
    end
    
    context 'when body is missing' do
      subject(:resource) do
        message.body = nil
        message
      end
      it { expect { resource.deliver! }.to raise_error CmSms::Message::BodyMissing }
    end
    
    context 'when body is to long' do
      subject(:resource) do
        message.body = [message.body, message.body].join # 2 x 160 signs
        message
      end
      it { expect { resource.deliver! }.to raise_error CmSms::Message::BodyToLong }
    end
    
    context 'when to is not plausibe' do
      subject(:resource) do
        message.to = 'fuubar'
        message
      end
      it { expect { resource.deliver! }.to raise_error CmSms::Message::ToUnplausible }
    end
    
    context 'when all needed attributes set' do
      before do 
        CmSms.configure { |config| config.product_token = 'SOMETOKEN' }
        request = instance_double(CmSms::Request)
        allow(request).to receive(:perform).and_return(true)
        allow(message).to receive(:request).and_return(request)
      end
      it { expect(message.deliver).to be true }
    end
  end
  
  describe '#request' do
    it { expect(message.request).to be_kind_of(CmSms::Request) }
  end
  
  describe '#to_xml' do
    before { CmSms.configure { |config| config.product_token = 'SOMETOKEN' } }
    
    context 'when all attributes set' do
      let(:xml_body) { '<?xml version="1.0" encoding="UTF-8"?><MESSAGES><AUTHENTICATION><PRODUCTTOKEN>SOMETOKEN</PRODUCTTOKEN></AUTHENTICATION><MSG><FROM>ACME corp.</FROM><TO>+41 44 111 22 33</TO><BODY>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirood tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At v</BODY><REFERENCE>Ref:123</REFERENCE></MSG></MESSAGES>' }
      it { expect(message.to_xml).to eq xml_body }
    end    
    
    context 'when reference is missing' do
      subject(:resource) do
        message.reference = nil
        message
      end
      let(:xml_body) { '<?xml version="1.0" encoding="UTF-8"?><MESSAGES><AUTHENTICATION><PRODUCTTOKEN>SOMETOKEN</PRODUCTTOKEN></AUTHENTICATION><MSG><FROM>ACME corp.</FROM><TO>+41 44 111 22 33</TO><BODY>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirood tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At v</BODY></MSG></MESSAGES>' }
      it { expect(resource.to_xml).to eq xml_body }
    end
  end
end
