require 'spec_helper'

describe CmSms::Configuration do
  
  it 'has a endpoit default' do
    expect(CmSms::Configuration::ENDPOINT).to be 'https://sgw01.cm.nl'
  end
  
  it 'has a path default' do
    expect(CmSms::Configuration::PATH).to be '/gateway.ashx'
  end
end
