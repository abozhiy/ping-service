# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
describe Ips::Services::SwitchStat::Enable do
  describe '.call' do
    subject(:call) { described_class.call(uuid: uuid, logger: fake_logger) }

    before do
      allow(Logger).to receive(:new).and_return fake_logger
      allow(fake_logger).to receive(:error).and_return true
    end

    let(:fake_logger) { instance_double(Logger) }
    let!(:ip)         { create :ip, enabled: false }

    context 'when ip does not exist' do
      let(:uuid)         { SecureRandom.uuid }
      let(:expected_msg) { 'Ip address does not exist.' }

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
    end

    context 'when ip exist' do
      let(:uuid) { ip.id }

      it 'is successful' do
        expect(call).to be_success
      end

      it 'returns uuid' do
        expect(call.uuid).to eq uuid
      end

      it 'changes enabled field to true' do
        expect(DB[:ips].where(id: uuid).first[:enabled]).to be_falsey
        call
        expect(DB[:ips].where(id: uuid).first[:enabled]).to be_truthy
      end
    end

    context 'when raise error' do
      before do
        allow(Ips::Repositories::Ip).to receive(:update).and_raise(Sequel::Error)
      end

      let(:uuid) { ip.id }

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
# rubocop:enable Metrics/BlockLength
