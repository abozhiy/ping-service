# frozen_string_literal: true

module Ips
  module Services
    # Service allows to ping IP address and parse it result
    class Ping
      attr_reader :rtt_min, :rtt_max, :rtt_avg, :rtt_stddev, :lost_packets

      TIMEOUT = 2
      COUNT = 5

      def initialize(ip:, timeout:, count:)
        @ip = ip
        @timeout = timeout
        @count = count
      end

      def self.call(ip:, timeout: TIMEOUT, count: COUNT)
        new(ip: ip, timeout: timeout, count: count).call
      end

      def call
        parse_rtt
        parse_lost_packets
        self
      end

      private

      def ping
        @ping ||= `ping -t #{@timeout} -c #{@count} #{@ip}`
      end

      def not_rtt?
        [@rtt_min, @rtt_max, @rtt_avg, @rtt_stddev].all?(&:nil?)
      end

      def parse_rtt
        return [] if ping.nil?

        result = ping[/stddev = (.*?) ms\n/m, 1]
        return [] if result.nil?

        @rtt_min, @rtt_max, @rtt_avg, @rtt_stddev, @lost_packets = result.split('/').map(&:to_f)
      end

      def parse_lost_packets
        return if ping.nil?

        result = ping[/received, (.*?)% packet loss/m, 1]
        return if result.nil?

        @lost_packets = result.to_f
      end
    end
  end
end
