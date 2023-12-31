# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
describe Ips::Operations::StatsCollectionOperation do
  describe '.call' do
    subject(:call) { described_class.call(batch: batch, logger: fake_logger) }

    before do
      allow(Logger).to receive(:new).and_return fake_logger
      allow(fake_logger).to receive(:error).and_return true
    end

    let(:fake_logger)  { instance_double(Logger) }
    let!(:ip)          { create :ip }
    let(:batch)        { DB[:ips].all }
    let(:min)          { 0.058 }
    let(:avg)          { 0.088 }
    let(:max)          { 0.117 }
    let(:stddev)       { 0.029 }
    let(:lost_packets) { 33.3 }

    context 'when success ping' do
      before do
        allow(Ips::Services::Ping).to receive(:call).and_return fake_ping
      end

      let(:fake_ping) do
        OpenStruct.new(
          rtt_min: min,
          rtt_max: max,
          rtt_avg: avg,
          rtt_stddev: stddev,
          lost_packets: lost_packets
        )
      end

      let(:expected) do
        {
          rtt_min: min,
          rtt_max: max,
          rtt_avg: avg,
          rtt_stddev: stddev,
          lost_packets: lost_packets
        }
      end

      it 'creates new row for states relation' do
        expect(DB[:stats].where(ip_id: ip.id).count).to eq 0
        call
        expect(DB[:stats].where(ip_id: ip.id).count).to eq 1
      end

      it 'has exact data from ping' do
        call
        stats_data = DB[:stats].where(ip_id: ip.id)
                               .select(:rtt_min, :rtt_max, :rtt_avg, :rtt_stddev, :lost_packets)
                               .first

        expect(stats_data).to eq expected
      end
    end

    context 'when failed ping' do
      before do
        allow(Ips::Services::Ping).to receive(:call).and_return fake_ping
        allow(fake_ping).to receive(:not_rtt?).and_return true
      end

      let(:fake_ping) { OpenStruct.new }

      it 'pushes message to logger' do
        call
        expect(fake_logger).to have_received(:error)
      end

      it 'does not create new row for stats relation' do
        expect(DB[:stats].count).to eq 0
        call
        expect(DB[:stats].count).to eq 0
      end
    end

    context 'when raise error' do
      before do
        allow(Ips::Repositories::Stat).to receive(:create).and_raise(Sequel::Error)
      end

      it { expect { call }.not_to raise_error }

      it 'pushes message to logger' do
        call
        expect(fake_logger).to have_received(:error)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
