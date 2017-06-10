require 'spec_helper'
require 'cm_sms/configuration'

RSpec.describe CmSms::Configuration do

  it 'has a endpoit set in constant' do
    expect(CmSms::Configuration::ENDPOINT).to eq 'https://sgw01.cm.nl'
  end

  it 'has a path default' do
    expect(CmSms::Configuration::PATH).to eq '/gateway.ashx'
  end

  let(:config) { described_class.new }

  describe '#endpoint' do
    context 'when endpoint is set through setter' do
      subject(:resource) do
        config.endpoint = 'http://local.host'
        config
      end
      it 'returns the setted endpoint' do
        expect(resource.endpoint).to eq 'http://local.host'
      end
    end

    context 'when endpoint is not set' do
      it 'returns the default enpoint set in constant' do
        expect(config.endpoint).to eq CmSms::Configuration::ENDPOINT
      end
    end
  end

  describe '#path' do
    context 'when path is set through setter' do
      subject(:resource) do
        config.path = '/example'
        config
      end
      it 'returns the setted path' do
        expect(resource.path).to eq '/example'
      end
    end

    context 'when path is not set' do
      it 'returns the default enpoint set in constant' do
        expect(config.path).to eq CmSms::Configuration::PATH
      end
    end
  end

  describe '#dcs' do
    context 'when dcs is set through setter' do
      subject(:resource) do
        config.dcs = 8
        config
      end
      it 'returns the setted dcs' do
        expect(resource.dcs).to eq 8
      end
    end

    context 'when dcs is not set' do
      it 'returns the default enpoint set in constant' do
        expect(config.dcs).to eq CmSms::Configuration::DCS
      end
    end
  end

  describe '#product_token' do
    context 'when product_token is set through setter' do
      subject(:resource) do
        config.product_token = 'SOMETOKEN'
        config
      end
      it 'returns the setted product_token' do
        expect(resource.product_token).to eq 'SOMETOKEN'
      end
    end

    context 'when product_token is set through api_key setter' do
      subject(:resource) do
        config.api_key = 'SOMEKEY'
        config
      end
      it 'returns the setted product_token' do
        expect(resource.product_token).to eq 'SOMEKEY'
      end
    end
  end

  describe '#from' do
    context 'when from is set through setter' do
      subject(:resource) do
        config.from = 'me'
        config
      end
      it 'returns the setted from' do
        expect(resource.from).to eq 'me'
      end
    end
  end

  describe '#to' do
    context 'when to is set through setter' do
      subject(:resource) do
        config.to = 'you'
        config
      end
      it 'returns the setted to' do
        expect(resource.to).to eq 'you'
      end
    end
  end

  describe '#defaults' do
    it 'returns confog defaults' do
      expect(config.defaults.key?(:from)).to be true
      expect(config.defaults.key?(:to)).to be true
    end
  end
end
