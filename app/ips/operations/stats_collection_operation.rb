# frozen_string_literal: true

module Ips
  module Operations
    # Statistics collector operation
    class StatsCollectionOperation
      POOL_SIZE = 10

      def initialize(batch:, logger:, repo:)
        @batch = batch
        @repo = repo
        @logger = logger
      end

      def self.call(batch:, logger:, repo: Repositories::Stat)
        new(batch: batch, repo: repo, logger: logger).call
      end

      def call
        Parallel.each(@batch, in_threads: pool_size) do |ip|
          ping = Services::Ping.call(ip: ip[:address])

          if ping.not_rtt? || ping.lost_packets.nil?
            @logger.error "PingTransmitFailedError, ip: #{ip[:address]}"
            next
          end

          create_stat(ip: ip, ping: ping)
        end
      rescue StandardError => e
        @logger.error e.message
      end

      private

      def pool_size
        return 0 if ENV['RACK_ENV'].eql? 'test'

        POOL_SIZE
      end

      def create_stat(ip:, ping:)
        @repo.create(
          ip_id: ip[:id],
          rtt_min: ping.rtt_min,
          rtt_max: ping.rtt_max,
          rtt_avg: ping.rtt_avg,
          rtt_stddev: ping.rtt_stddev,
          lost_packets: ping.lost_packets
        )
      end
    end
  end
end
