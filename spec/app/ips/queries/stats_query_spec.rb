# frozen_string_literal: true

describe Ips::Queries::StatsQuery do
  describe '.call' do
    subject(:call) { described_class.call(uuid: uuid, time_from: time_from, time_to: time_to) }

    before do
      fake_ping_data.each do |data|
        create(:stat,
               ip_id: ip.id,
               rtt_min: data[:rtt_min],
               rtt_max: data[:rtt_max],
               rtt_avg: data[:rtt_avg],
               rtt_stddev: data[:rtt_stddev],
               lost_packets: data[:lost_packets],
               created_at: data[:created_at])

      end
    end

    let(:ip)        { create :ip }
    let(:uuid)      { ip.id }
    let(:time_from) { '2023-12-17 17:24:00' }
    let(:time_to)   { '2023-12-17 17:30:00' }

    let(:fake_ping_data) do
      [
        {
          rtt_min: 4,
          rtt_max: 6,
          rtt_avg: 5,
          rtt_stddev: 2,
          lost_packets: 0.8,
          created_at: '2023-12-17 17:25:00'
        },
        {
          rtt_min: 2,
          rtt_max: 7,
          rtt_avg: 4,
          rtt_stddev: 1,
          lost_packets: 0.4,
          created_at: '2023-12-17 17:27:00'
        },
        {
          rtt_min: 5,
          rtt_max: 9,
          rtt_avg: 7,
          rtt_stddev: 3,
          lost_packets: 0.2,
          created_at: '2023-12-17 17:29:00'
        }
      ]
    end

    context 'when success' do
      let(:expected) do
        {
          rtt_min: 2.0,
          rtt_max: 9.0,
          rtt_avg: 5.333,
          rtt_median: 5.0,
          rtt_stddev: 2.0,
          lost_packets: 0.467
        }
      end

      it 'returns array' do
        expect(call).to be_an_instance_of(Array)
      end

      it 'returns exact data' do
        expect(call).to contain_exactly expected
      end
    end

    context 'when uuid of non-existing ip has sent' do
      let(:uuid) { SecureRandom.uuid }

      it 'returns array' do
        expect(call).to be_an_instance_of(Array)
      end

      it 'should be empty' do
        expect(call).to be_empty
      end
    end
  end
end
