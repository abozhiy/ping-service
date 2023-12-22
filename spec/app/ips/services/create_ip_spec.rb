# frozen_string_literal: true

describe Ips::Services::CreateIp do
  describe '.call' do
    subject(:call) do
      described_class.call(
        validation_result: fake_result,
        logger: fake_logger
      )
    end

    before do
      allow(Logger).to receive(:new).and_return fake_logger
      allow(fake_logger).to receive(:error).and_return true

      allow(Dry::Validation::Result).to receive(:new).and_return fake_result
      allow(fake_result).to receive(:failure?).and_return false
    end

    let(:fake_logger) { instance_double(Logger) }
    let(:ip_address)  { '127.0.0.1' }
    let(:enabled)     { true }
    let(:fake_result) { instance_double(Dry::Validation::Result, to_h: fake_result_hash) }

    let(:fake_result_hash) do
      {
        ip: {
          ip_address: ip_address,
          enabled: enabled
        }
      }
    end

    context 'when ip not exist yet' do
      it 'is successful' do
        expect(call).to be_success
      end

      it 'returns valid uuid' do
        expect(call.uuid).to eq DB[:ips].all.first[:id]
      end

      it 'creates new row for ips relation' do
        expect(DB[:ips].count).to eq 0
        call
        expect(DB[:ips].count).to eq 1
      end
    end

    context 'when ip already exist' do
      let!(:ip)          { create :ip, address: ip_address }
      let(:expected_msg) { 'Ip address already exist.' }

      it 'is not successful' do
        expect(call).not_to be_success
      end

      it 'returns message' do
        expect(call.message).to eq expected_msg
      end

      it 'pushes message to logger' do
        call
        expect(fake_logger).to have_received(:error)
      end

      it 'does not create new row for ips relation' do
        expect(DB[:ips].count).to eq 1
        call
        expect(DB[:ips].count).to eq 1
      end
    end

    context 'when raise error' do
      before do
        allow(Ips::Repositories::Ip).to receive(:create).and_raise(Sequel::Error)
      end

      it { expect { call }.not_to raise_error }

      it 'is not successful' do
        expect(call).not_to be_success
      end

      it 'returns message' do
        expect(call.message).to eq 'Sequel::Error'
      end
    end
  end
end
