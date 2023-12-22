# frozen_string_literal: true

module Ips
  module Services
    class CreateIp < BaseService
      attr_reader :uuid

      def initialize(repo:, validation_result:, logger:)
        @repo = repo
        @logger = logger
        @validation_result = validation_result
        @uuid = ''

        super
      end

      def self.call(repo: Repositories::Ip, validation_result:, logger:)
        new(repo: repo, validation_result: validation_result, logger: logger).call
      end

      def call
        wrap do
          if @validation_result.failure?
            @message = @validation_result.errors.messages.first.text
            return self
          end

          ip = @repo.find_by(address: params.dig(:ip, :ip_address))
          raise IpAlreadyExistError, 'Ip address already exist.' unless ip.nil?

          @uuid = @repo.create(
            address: params.dig(:ip, :ip_address),
            enabled: params.dig(:ip, :enabled)
          )
          @result = true
          self
        end
      end

      private

      def params
        @params ||= @validation_result.to_h
      end
    end
  end
end
