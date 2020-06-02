require 'spec_helper'
require 'cm_sms/message'

RSpec.describe CmSms::Message do
  let(:message_body) { 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirood tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At v' }

  let(:product_token) { nil }
  let(:endpoints) { nil }

  let(:message) do
    message = described_class.new
    message.from = 'ACME'
    message.to = '+41 44 111 22 33'
    message.body = message_body
    message.reference = 'Ref:123'
    message.product_token = product_token
    message.endpoints = endpoints
    message
  end

  describe '#dcs_numeric?' do
    context 'when dcs is provided as number' do
      it { expect(message.dcs_numeric?).to be true }
    end

    context 'when dcs is provided not as number' do
      subject(:resource) do
        message.dcs = 'Fuubar'
        message
      end
      it { expect(resource.dcs_numeric?).to be false }
    end
  end

  describe '#receiver_plausible?' do
    context 'when a valid phone number is provided' do
      it { expect(message.receiver_plausible?).to be true }
    end

    context 'phony present' do
      context 'when a invalid phone number is provided' do
        subject(:resource) do
          message.to = 'Fuubar'
          message
        end
        it { expect(resource.receiver_plausible?).to be false }
      end
    end

    context 'phonelib present' do
      before { hide_const('Phony') }
      context 'when a invalid phone number is provided' do
        subject(:resource) do
          message.to = 'Fuubar'
          message
        end
        it { expect(resource.receiver_plausible?).to be false }
      end
    end

    context 'neither phony nor phonelib present' do
      before do
        hide_const('Phony')
        hide_const('Phonelib')
      end
      context 'when a invalid phone number is provided' do
        subject(:resource) do
          message.to = 'Fuubar'
          message
        end
        it { expect(resource.receiver_plausible?).to be true }
      end
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

  describe '#endpoints' do
    context 'when a endpoints configured at config level' do
      before { CmSms.configure { |config| config.endpoints = %w[bazqux bingbaz] } }
      it { expect(message.endpoints).to eq %w[bazqux bingbaz] }

      context 'when a endpoints set on message' do
        let(:endpoints) { 'foobar' }
        it { expect(message.endpoints).to eq ['foobar'] }
      end
    end

    context 'when no endpoints is provided' do
      before { CmSms.configure { |config| config.endpoints = nil } }
      it { expect(message.endpoints).to eq %w[https://gw.cmtelecom.com] }

      context 'when a endpoints set on message' do
        let(:endpoints) { 'foobar' }
        it { expect(message.endpoints).to eq ['foobar'] }
      end
    end
  end

  describe '#product_token and #product_token_present?' do
    context 'when a product_token configured at config level' do
      before { CmSms.configure { |config| config.product_token = 'SOMETOKEN' } }
      it { expect(message.product_token).to eq 'SOMETOKEN' }
      it { expect(message.product_token_present?).to eq true }

      context 'when a product_token set on message' do
        let(:product_token) { 'MSGTOKEN' }
        it { expect(message.product_token).to eq 'MSGTOKEN' }
        it { expect(message.product_token_present?).to eq true }
      end
    end

    context 'when no product_token is provided' do
      before { CmSms.configure { |config| config.product_token = nil } }
      it { expect(message.product_token).to eq nil }
      it { expect(message.product_token_present?).to eq false }

      context 'when a product_token set on message' do
        let(:product_token) { 'MSGTOKEN' }
        it { expect(message.product_token).to eq 'MSGTOKEN' }
        it { expect(message.product_token_present?).to eq true }
      end
    end

    context 'when no product_token is blank' do
      before { CmSms.configure { |config| config.product_token = '' } }
      it { expect(message.product_token).to eq '' }
      it { expect(message.product_token_present?).to eq false }
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

    context 'when product token is given' do
      before { CmSms.configure { |config| config.product_token = 'SOMETOKEN' } }
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
        it { expect { resource.deliver! }.to raise_error CmSms::Message::BodyTooLong }
      end

      context 'when to is not plausibe' do
        subject(:resource) do
          message.to = 'fuubar'
          message
        end
        it { expect { resource.deliver! }.to raise_error CmSms::Message::ToUnplausible }
      end

      context 'when dcs is not a number' do
        subject(:resource) do
          message.dcs = 'fuubar'
          message
        end
        it { expect { resource.deliver! }.to raise_error CmSms::Message::DCSNotNumeric }
      end
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
    before { CmSms.configure { |config| config.endpoints = nil } }

    it { expect(message.request).to be_kind_of(CmSms::Request) }

    it do
      expect(CmSms::Request).to receive(:new).with(message.to_xml, %w[https://gw.cmtelecom.com])
      message.request
    end

    context 'when endpoints set' do
      let(:endpoints) { 'foobar' }
      it do
        expect(CmSms::Request).to receive(:new).with(message.to_xml, %w[foobar])
        message.request
      end
    end
  end

  describe '#to_xml' do
    before { CmSms.configure { |config| config.product_token = 'SOMETOKEN' } }

    context 'when all attributes set' do
      let(:xml_body) { '<?xml version="1.0" encoding="UTF-8"?><MESSAGES><AUTHENTICATION><PRODUCTTOKEN>SOMETOKEN</PRODUCTTOKEN></AUTHENTICATION><MSG><FROM>ACME</FROM><TO>+41 44 111 22 33</TO><BODY>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirood tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At v</BODY><REFERENCE>Ref:123</REFERENCE></MSG></MESSAGES>' }
      it { expect(message.to_xml).to eq xml_body }
    end

    context 'when reference is missing' do
      subject(:resource) do
        message.reference = nil
        message
      end
      let(:xml_body) { '<?xml version="1.0" encoding="UTF-8"?><MESSAGES><AUTHENTICATION><PRODUCTTOKEN>SOMETOKEN</PRODUCTTOKEN></AUTHENTICATION><MSG><FROM>ACME</FROM><TO>+41 44 111 22 33</TO><BODY>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirood tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At v</BODY></MSG></MESSAGES>' }
      it { expect(resource.to_xml).to eq xml_body }
    end
  end
end
