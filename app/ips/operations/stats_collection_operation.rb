# frozen_string_literals = true

module Ips
  module Operations
    class StatsCollectionOperation
      POOL_SIZE = 10

      def initialize(batch:, repo:, logger:)
        @batch = batch
        @repo = repo
        @logger = logger
      end

      def self.call(batch:, repo: Repositories::Stat, logger:)
        new(batch: batch, repo: repo, logger: logger).call
      end

      def call
        Parallel.each(@batch, in_threads: pool_size) do |ip|
          ping = Services::Ping.call(ip: ip[:address])
          min, avg, max, stddev = parse_rtt(ping)
          lost_packets = parse_lost_packets(ping)

          if [min, avg, max, stddev].all?(&:nil?) || lost_packets.nil?
            @logger.error "PingTransmitFailedError, ip: #{ip[:address]}"
            next
          end

          @repo.create(
            ip_id: ip[:id],
            rtt_min: min,
            rtt_max: max,
            rtt_avg: avg,
            rtt_stddev: stddev,
            lost_packets: lost_packets
          )
        end
      rescue StandardError => e
        @logger.error e.message
      end

      private

      def parse_rtt(str)
        return [] if str.nil?

        result = str[/stddev = (.*?) ms\n/m, 1]
        return [] if result.nil?

        result.split('/').map(&:to_f)
      end

      def parse_lost_packets(str)
        return if str.nil?

        result = str[/received, (.*?)% packet loss/m, 1]
        return if result.nil?

        result.to_f
      end

      def pool_size
        return 0 if ENV['RACK_ENV'].eql? 'test'

        POOL_SIZE
      end
    end
  end
end
