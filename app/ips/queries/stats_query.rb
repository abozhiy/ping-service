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
            rtt_min, 
            rtt_max, 
            rtt_avg, 
            rtt_stddev, 
            (
              SELECT percentile_cont(0.5) within group ( order by rtt_avg )
              FROM stats
              WHERE stats.ip_id = :uuid
              AND stats.created_at BETWEEN :time_from AND :time_to
            ) AS rtt_median,
            lost_packets, 
            created_at
          
          FROM stats

          WHERE stats.ip_id = :uuid
          AND stats.created_at BETWEEN :time_from AND :time_to
          ORDER BY stats.created_at DESC
        SQL
      end
    end
  end
end
