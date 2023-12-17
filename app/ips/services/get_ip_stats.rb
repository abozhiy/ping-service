# frozen_string_literal: true

module Ips
  module Services
    class GetIpStats < BaseService
      attr_reader :data

      def initialize(uuid:, time_from:, time_to:, logger:)
        @uuid = uuid
        @time_from = time_from
        @time_to = time_to
        @logger = logger
        @data = stats_query

        super
      end

      def self.call(uuid:, time_from:, time_to:, logger:)
        new(uuid: uuid, time_from: time_from, time_to: time_to, logger: logger).call
      end

      def call
        wrap do
          if @data.empty?
            @result = false
            @message = 'There is no data on the requested ip address.'
          else
            @result = true
          end
          self
        end
      end

      private

      def stats_query
        @stats_query ||= Queries::StatsQuery.call(
          uuid: @uuid,
          time_from: @time_from,
          time_to: @time_to,
          logger: @logger
        )
      end
    end
  end
end
