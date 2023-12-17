# frozen_string_literal: true

module Ips
  module Services
    class GetIpStats < BaseService
      attr_reader :data

      def initialize(uuid:, time_from:, time_to:, logger:, contract:)
        @uuid = uuid
        @time_from = time_from
        @time_to = time_to
        @contract = contract
        @logger = logger
        @data = []

        super
      end

      def self.call(uuid:, time_from:, time_to:, logger:, contract:)
        new(uuid: uuid, time_from: time_from, time_to: time_to, logger: logger, contract: contract).call
      end

      def call
        wrap do
          if @contract.failure?
            @message = @contract.errors.messages.first.text
            return self
          end

          if (@data = stats_query).empty?
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
          time_to: @time_to
        )
      end
    end
  end
end
