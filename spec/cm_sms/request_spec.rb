require 'spec_helper'
require 'cm_sms/request'

RSpec.describe CmSms::Request do
  let(:message_body) { 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirood tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At v' }
  let(:message) do
    message = CmSms::Message.new
    message.from = 'ACME'
    message.to = '+41 44 111 22 33'
    message.body = message_body
    message.reference = 'Ref:123'
    message
  end
  let(:request_body) { message.to_xml }
  let(:endpoints) { nil }
  let(:request) { described_class.new(request_body, endpoints) }

  describe '@endpoint' do
    before { CmSms.configuration.endpoints = nil }

    context 'endpoint is randomized to sgw01' do
      before { srand(0) }
      it { expect(request.instance_variable_get('@endpoint')).to eq 'https://sgw01.cm.nl' }
    end

    context 'endpoint is randomized to sgw02' do
      before { srand(1) }
      it { expect(request.instance_variable_get('@endpoint')).to eq 'https://sgw02.cm.nl' }
    end

    context 'when endpoints arg set' do
      let(:endpoints) { %w[foobar bazqux] }
      before { srand(0) }
      it { expect(request.instance_variable_get('@endpoint')).to eq 'foobar' }
    end
  end

  describe '#perform' do
    context 'when the API endpoint is missing' do
      let(:resource) do
        request.instance_variable_set('@endpoint', nil)
        request
      end
      it { expect { resource.perform }.to raise_error CmSms::Configuration::EndpointMissing }
    end

    context 'when the API path is missing' do
      let(:resource) do
        request.instance_variable_set('@path', nil)
        request
      end
      it { expect { resource.perform }.to raise_error CmSms::Configuration::PathMissing }
    end

    context 'when request was successful' do
      it 'return a instance CmSms::Response' do
        http_response = Net::HTTPOK.new('post', 200, 'found')
        http_response.content_type = 'text/xml'
        allow(http_response).to receive(:body).and_return('')
        response = CmSms::Response.new(http_response)

        allow_any_instance_of(described_class).to receive(:perform).and_return(response)
        expect(request.perform.success?).to be true
      end
    end
  end
end
