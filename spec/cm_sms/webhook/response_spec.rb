require 'spec_helper'
require 'cm_sms/webhook/response'

RSpec.describe CmSms::Webhook::Response do
  let(:response_params) do
    {
      sent:       '2009-06-15T13:45:30',
      received:   '2009-06-15T13:45:30',
      to:         '+41 44 111 22 33',
      reference:  'gid://app/Message/1c',
      statuscode: 0
    }
  end
  
  let(:response) do 
    described_class.new(response_params)
  end
  
  describe '#sent?' do
    context 'when sent is given' do
      subject { response.sent? }
      it { expect(subject).to be true }
    end
    
    context 'when sent is missing' do
      subject { described_class.new(response_params.merge(sent: nil)) }
      it { expect(subject.sent?).to be false }
    end
  end
  
  describe '#received?' do
    context 'when received is given' do
      subject { response.received? }
      it { expect(subject).to be true }
    end
    
    context 'when received is missing' do
      subject { described_class.new(response_params.merge(received: nil)) }
      it { expect(subject.received?).to be false }
    end
  end
  
  describe '#statuscode?' do
    context 'when status code is given' do
      subject { response.statuscode? }
      it { expect(subject).to be true }
    end
    
    context 'when status code is missing' do
      subject { described_class.new(response_params.merge(statuscode: nil)) }
      it { expect(subject.statuscode?).to be false }
    end
  end
  
  describe '#errorcode?' do
    context 'when error code is missing' do
      it { expect(response.errorcode?).to be false }
    end
    
    context 'when error code is given' do
      subject { described_class.new(response_params.merge(errocode: 1)) }
      it { expect(subject.errorcode?).to be false }
    end
  end
  
  describe '#sent_at' do
    context 'when sent is given' do
      subject { response.sent_at }
      it { expect(subject).to be_kind_of Time }
      it { expect(subject).to eq Time.parse(response_params[:sent]) }
    end
    
    context 'when sent is missing' do
      subject { described_class.new(response_params.merge(sent: nil)) }
      it { expect(subject.sent_at).to be_nil }
    end
  end
  
  describe '#received_at' do
    context 'when received is given' do
      subject { response.received_at }
      it { expect(subject).to be_kind_of Time }
      it { expect(subject).to eq Time.parse(response_params[:received]) }
    end
    
    context 'when received is missing' do
      subject { described_class.new(response_params.merge(received: nil)) }
      it { expect(subject.received_at).to be_nil }
    end
  end
  
  describe '#accepted?' do
    context 'when statuscode is set to 0' do
      it { expect(response.accepted?).to be true } 
    end
    
    context 'when statuscode is not set to 0' do
      subject { described_class.new(response_params.merge(statuscode: 1)) }
      it { expect(subject.accepted?).to be false } 
    end
  end
  
  describe '#rejected?' do
    context 'when statuscode is set to 1' do
      subject { described_class.new(response_params.merge(statuscode: 1)) }
      it { expect(subject.rejected?).to be true } 
    end
    
    context 'when statuscode is not set to 1' do
      it { expect(response.rejected?).to be false } 
    end
  end
  
  describe '#delivered?' do
    context 'when statuscode is set to 2' do
      subject { described_class.new(response_params.merge(statuscode: 2)) }
      it { expect(subject.delivered?).to be true } 
    end
    
    context 'when statuscode is not set to 2' do
      it { expect(response.delivered?).to be false } 
    end
  end
  
  describe '#failed?' do
    context 'when statuscode is set to 2' do
      subject { described_class.new(response_params.merge(statuscode: 3)) }
      it { expect(subject.failed?).to be true } 
    end
    
    context 'when statuscode is not set to 2' do
      it { expect(response.failed?).to be false } 
    end
  end
  
  describe '#error?' do
    context 'when errorcode is set' do
      subject { described_class.new(response_params.merge(errorcode: 1)) }
      it { expect(subject.error?).to be true } 
    end
    
    context 'when rejected? returns true' do
      subject { described_class.new(response_params.merge(statuscode: 1)) }
      it { expect(subject.error?).to be true } 
    end
    
    context 'when failed? returns true' do
      subject { described_class.new(response_params.merge(statuscode: 3)) }
      it { expect(subject.error?).to be true } 
    end
  end
  
  describe '#to_yaml' do
    subject { described_class.new(response_params).to_yaml }
    it { expect(subject).to eq response_params.to_yaml }
  end
  
end