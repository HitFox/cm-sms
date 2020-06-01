require 'spec_helper'
require 'cm_sms/configuration'

RSpec.describe CmSms::Configuration do
  it 'has a endpoit set in constant' do
    expect(CmSms::Configuration::ENDPOINTS).to eq %w[https://sgw01.cm.nl https://sgw02.cm.nl]
  end

  it 'has a path default' do
    expect(CmSms::Configuration::PATH).to eq '/gateway.ashx'
  end

  let(:config) { described_class.new }

  describe '#endpoints' do
    context 'when endpoint is set through setter' do
      subject(:resource) do
        config.endpoint = 'http://local.host'
        config
      end
      it 'returns the set endpoint' do
        expect(resource.endpoints).to eq ['http://local.host']
      end
    end

    context 'when endpoints is set through setter' do
      subject(:resource) do
        config.endpoints = %w[http://local.host http://other.host]
        config
      end
      it 'returns the set endpoint' do
        expect(resource.endpoints).to eq %w[http://local.host http://other.host]
      end
    end

    context 'when endpoints is not set' do
      it 'returns the default endpoints set in constant' do
        expect(config.endpoints).to eq CmSms::Configuration::ENDPOINTS
      end
    end
  end

  describe '#path' do
    context 'when path is set through setter' do
      subject(:resource) do
        config.path = '/example'
        config
      end
      it 'returns the set path' do
        expect(resource.path).to eq '/example'
      end
    end

    context 'when path is not set' do
      it 'returns the default path set in constant' do
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
      it 'returns the set dcs' do
        expect(resource.dcs).to eq 8
      end
    end

    context 'when dcs is not set' do
      it 'returns the default dcs set in constant' do
        expect(config.dcs).to eq CmSms::Configuration::DCS
      end
    end
  end

  describe '#timeout' do
    context 'when timeout is set through setter' do
      subject(:resource) do
        config.timeout = 20
        config
      end
      it 'returns the set timeout' do
        expect(resource.timeout).to eq 20
      end
    end

    context 'when timeout is not set' do
      it 'returns the default timeout set in constant' do
        expect(config.timeout).to eq CmSms::Configuration::TIMEOUT
      end
    end
  end

  describe '#product_token' do
    context 'when product_token is set through setter' do
      subject(:resource) do
        config.product_token = 'SOMETOKEN'
        config
      end
      it 'returns the set product_token' do
        expect(resource.product_token).to eq 'SOMETOKEN'
      end
    end

    context 'when product_token is set through api_key setter' do
      subject(:resource) do
        config.api_key = 'SOMEKEY'
        config
      end
      it 'returns the set product_token' do
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
      it 'returns the set from' do
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
      it 'returns the set to' do
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
