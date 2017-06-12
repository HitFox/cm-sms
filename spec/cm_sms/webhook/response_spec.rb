require 'spec_helper'
require 'cm_sms/webhook/response'

RSpec.describe CmSms::Webhook::Response do
  let(:response_params) do
    {
      created_s:          '2009-06-15T13:45:30',
      datetime_s:         '2009-06-15T13:45:30',
      gsm:                '+41 44 111 22 33',
      reference:          'gid://app/Message/1c',
      standarderrortext:  '',
      status:             0,
      statusdescription:  '',
      statusissuccess:    1
    }
  end

  let(:response) do
    described_class.new(response_params)
  end

  describe '#statusissuccess?' do
    context 'when statusissucess is given' do
      subject { response.statusissuccess? }
      it { expect(subject).to be true }
    end

    context 'when sent is missing' do
      subject { described_class.new(response_params.merge(statusissuccess: nil)) }
      it { expect(subject.statusissuccess?).to be false }
    end
  end

  describe '#status?' do
    context 'when status is given' do
      subject { response.status? }
      it { expect(subject).to be true }
    end

    context 'when status is missing' do
      subject { described_class.new(response_params.merge(status: nil)) }
      it { expect(subject.status?).to be false }
    end
  end

  describe '#received_at' do
    context 'when datetime_s is given' do
      subject { response.received_at }
      it { expect(subject).to be_kind_of Time }
      it { expect(subject).to eq Time.parse(response_params[:datetime_s]) }
    end

    context 'when received is missing' do
      subject { described_class.new(response_params.merge(datetime_s: nil)) }
      it { expect(subject.received_at).to be_nil }
    end
  end

  describe '#accepted?' do
    context 'when status is set to 0' do
      it { expect(response.accepted?).to be true }
    end

    context 'when statuscode is not set to 0' do
      subject { described_class.new(response_params.merge(status: 1)) }
      it { expect(subject.accepted?).to be false }
    end
  end

  describe '#rejected?' do
    context 'when statuscode is set to 1' do
      subject { described_class.new(response_params.merge(status: 1)) }
      it { expect(subject.rejected?).to be true }
    end

    context 'when statuscode is not set to 1' do
      it { expect(response.rejected?).to be false }
    end
  end

  describe '#delivered?' do
    context 'when statuscode is set to 2' do
      subject { described_class.new(response_params.merge(status: 2)) }
      it { expect(subject.delivered?).to be true }
    end

    context 'when statuscode is not set to 2' do
      it { expect(response.delivered?).to be false }
    end
  end

  describe '#failed?' do
    context 'when statuscode is set to 3' do
      subject { described_class.new(response_params.merge(status: 3)) }
      it { expect(subject.failed?).to be true }
    end

    context 'when statuscode is not set to 3' do
      it { expect(response.failed?).to be false }
    end
  end

  describe '#error?' do
    context 'when errorcode is set' do
      subject { described_class.new(response_params.merge(errorcode: 1)) }
      it { expect(subject.error?).to be true }
    end

    context 'when rejected? returns true' do
      subject { described_class.new(response_params.merge(status: 1)) }
      it { expect(subject.error?).to be true }
    end

    context 'when failed? returns true' do
      subject { described_class.new(response_params.merge(status: 3)) }
      it { expect(subject.error?).to be true }
    end
  end

  describe '#success?' do
    context 'when statusissuccess is set' do
      it { expect(response.success?).to be true }
    end

    context 'when statusissuccess is missing' do
      subject { described_class.new(response_params.merge(statusissuccess: nil)) }
      it { expect(subject.success?).to be false }
    end

    context 'when statusissuccess is 0' do
      subject { described_class.new(response_params.merge(statusissuccess: 0)) }
      it { expect(subject.success?).to be false }
    end
  end

  describe '#to_yaml' do
    subject { described_class.new(response_params).to_yaml }
    it { expect(subject).to eq response_params.to_yaml }
  end
end
