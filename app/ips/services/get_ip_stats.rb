# frozen_string_literal: true

module Ips
  module Services
    class GetIpStats < BaseService
      attr_reader :data

      def initialize(uuid:, validation_result:, logger:)
        @uuid = uuid
        @validation_result = validation_result
        @logger = logger
        @data = []

        super
      end

      def self.call(uuid:, validation_result:, logger:)
        new(uuid: uuid, validation_result: validation_result, logger: logger).call
      end

      def call
        wrap do
          if @validation_result.failure?
            @message = @validation_result.errors.messages.first.text
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
          time_from: params.dig(:time_from),
          time_to: params.dig(:time_to)
        )
      end

      def params
        @params ||= @validation_result.to_h
      end
    end
  end
end
