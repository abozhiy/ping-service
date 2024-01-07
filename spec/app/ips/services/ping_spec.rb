# frozen_string_literal: true

describe Ips::Services::Ping do
  describe '.call' do
    subject(:call) { described_class.call(ip: ip.address) }

    let!(:ip) { create :ip }

    shared_examples_for 'ping service result' do |attribute|
      it "returns exact #{attribute}" do
        ping_result = call
        expect(ping_result).to respond_to attribute
        expect(ping_result.send(attribute)).not_to be_nil
      end
    end

    it_behaves_like 'ping service result', :rtt_min
    it_behaves_like 'ping service result', :rtt_max
    it_behaves_like 'ping service result', :rtt_avg
    it_behaves_like 'ping service result', :rtt_stddev
    it_behaves_like 'ping service result', :lost_packets
  end
end
