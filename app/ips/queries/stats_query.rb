# frozen_string_literals = true

module Ips
  module Queries
    class StatsQuery
      def initialize(uuid:, time_from:, time_to:, logger:)
        @uuid = uuid
        @time_from = time_from
        @time_to = time_to
        @logger = logger
      end

      def self.call(uuid:, time_from:, time_to:, logger:)
        new(uuid: uuid, time_from: time_from, time_to: time_to, logger: logger).call
      end

      def call
        DB.fetch(sql, uuid: @uuid, time_from: @time_from, time_to: @time_to).all
      rescue StandardError => e
        @logger.error e
        nil
      end

      private

      def sql
        <<-SQL
          SELECT 
            stats.rtt_min,
            stats.rtt_max,
            stats.rtt_avg::FLOAT,
            (
              SELECT percentile_cont(0.5) within group ( order by rtt_avg )
              FROM stats
              WHERE stats.ip_id = :uuid
              AND stats.created_at BETWEEN :time_from AND :time_to
            ) AS rtt_median,
            stats.rtt_stddev::FLOAT,
            stats.lost_packets::FLOAT

          FROM (
            SELECT ip_id,
                MIN(rtt_min) as rtt_min,
                MAX(rtt_max) as rtt_max,
                ROUND(AVG(rtt_avg)::numeric, 3) as rtt_avg,
                ROUND(AVG(rtt_stddev)::numeric, 3) as rtt_stddev,
                ROUND(AVG(lost_packets)::numeric, 3) as lost_packets
            FROM stats

            WHERE stats.ip_id = :uuid
            AND stats.created_at BETWEEN :time_from AND :time_to

            GROUP BY ip_id
          ) AS stats
        SQL
      end
    end
  end
end
