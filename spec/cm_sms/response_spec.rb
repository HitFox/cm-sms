require 'spec_helper'
require 'cm_sms/response'

RSpec.describe CmSms::Response do
  let(:response) do 
    http_response = Net::HTTPOK.new('post', 200, 'found')
    http_response.content_type = 'text/xml'
    allow(http_response).to receive(:body).and_return('')
    described_class.new(http_response)
  end
  
  describe '#success?' do
    context 'when response is successful' do
      it { expect(response.success?).to be true }
    end
    
    context 'when response is failed' do
      subject(:resource) do
        http_response = Net::HTTPOK.new('post', 200, 'found')
        http_response.content_type = 'text/xml'
        allow(http_response).to receive(:body).and_return('Error: ERROR No FROM field found in a MSG node')
        described_class.new(http_response)
      end
      it { expect(resource.success?).to be false }
      it { expect(resource.failure?).to be true }
      it { expect(resource.error).to eq 'No FROM field found in a MSG node' }
    end
  end
end