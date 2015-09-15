require 'spec_helper'

describe CmSms do
  
  it 'has a version number' do
    expect(CmSms::VERSION).not_to be nil
    expect(CmSms.version).not_to be nil
  end


  it 'does something useful' do
    expect(false).to eq(true)
  end
end
