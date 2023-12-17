# frozen_string_literal: true

describe Ips::Services::GetIpStats do
  describe '.call' do
    subject(:call) do
      described_class.call(
        uuid: uuid,
        time_from: time_from,
        time_to: time_to,
        contract: fake_result,
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
    let(:fake_result) { instance_double(Dry::Validation::Result) }
    let(:uuid)        { SecureRandom.uuid }
    let(:time_from)   { '' }
    let(:time_to)     { '' }

    context 'when ip_stats data exist' do
      before do
        allow(Ips::Queries::StatsQuery).to receive(:call).and_return fake_data
      end

      let(:fake_data) do
        [
          {
            rtt_min: 36.912,
            rtt_max: 56.34,
            rtt_avg: 47.96,
            rtt_median: 48.3365,
            rtt_stddev: 2.922,
            lost_packets: 8.325
          }
        ]
      end

      it 'is successful' do
        expect(call).to be_success
      end

      it 'returns certain data' do
        expect(call.data).to eq fake_data
      end
    end

    context 'when ip_stats data does not exist' do
      before do
        allow(Ips::Queries::StatsQuery).to receive(:call).and_return fake_data
      end

      let(:fake_data) { [] }
      let(:expected_msg) { 'There is no data on the requested ip address.' }

      it 'is not successful' do
        expect(call).not_to be_success
      end

      it 'returns message' do
        expect(call.message).to eq expected_msg
      end
    end

    context 'when raise error' do
      before do
        allow(Ips::Queries::StatsQuery).to receive(:call).and_raise(Sequel::Error)
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
