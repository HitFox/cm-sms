require 'spec_helper'

RSpec.describe CmSms do
  
  it 'has a version number' do
    expect(CmSms::VERSION).not_to be nil
    expect(CmSms.version).not_to be nil
  end
  
  before do
    CmSms.configure do |config|
      config.from = '+41 44 111 22 33'
      config.to = '+41 44 111 22 33'
      config.product_token = 'SOMETOKEN'
      config.endpoint = 'http://example.com'
      config.path = '/example'
    end
  end
  
  describe '.configuration' do
    it 'delegates all defaults to the current configuration' do
      expect(CmSms.config.from).to eq '+41 44 111 22 33'
      expect(CmSms.config.to).to eq '+41 44 111 22 33'
      expect(CmSms.config.product_token).to eq 'SOMETOKEN'
      expect(CmSms.config.endpoint).to eq 'http://example.com'
      expect(CmSms.config.path).to eq '/example'
    end
  end
end
