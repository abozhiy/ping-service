# frozen_string_literals = true

module Ips
  module Operations
    class StatsCollectionOperation
      TIMEOUT = 2

      def initialize(batch:, repo:, logger:)
        @batch = batch
        @repo = repo
        @logger = logger
      end

      def self.call(batch:, repo: Repositories::Stat, logger:)
        new(batch: batch, repo: repo, logger: logger).call
      end

      def call
        thread_service.call do |ip|
          ping = `ping -t #{TIMEOUT} #{ip[:address]}`
          rtt = parse_rtt(ping)
          lost_packets = parse_lost_packets(ping)
          if rtt.nil? || lost_packets.nil?
            @logger.error "PingTransmitFailedError, ip: #{ip[:address]}"
            next
          end

          min, avg, max, stddev = rtt.split('/').map(&:to_f)
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
        str[/stddev = (.*?) ms\n/m, 1]
      end

      def parse_lost_packets(str)
        str[/received, (.*?)% packet loss/m, 1]
      end

      def thread_service
        ::Services::ThreadService.new(list: @batch, logger: @logger)
      end
    end
  end
end
