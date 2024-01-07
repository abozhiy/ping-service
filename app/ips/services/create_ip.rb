# frozen_string_literal: true

module Ips
  module Services
    # Service allows to create new IP rows
    class CreateIp < BaseService
      attr_reader :uuid

      def initialize(validation_result:, logger:, repo:)
        @repo = repo
        @logger = logger
        @validation_result = validation_result
        @uuid = ''

        super
      end

      def self.call(validation_result:, logger:, repo: Repositories::Ip)
        new(validation_result: validation_result, logger: logger, repo: repo).call
      end

      def call
        wrap do
          return self if validation_failure?

          ip = @repo.find_by(address: params.dig(:ip, :ip_address))
          raise IpAlreadyExistError, 'Ip address already exist.' unless ip.nil?

          @uuid = create_ip
          @result = true
          self
        end
      end

      private

      def params
        @params ||= @validation_result.to_h
      end

      def validation
        @validation_result
      end

      def create_ip
        @repo.create(
          address: params.dig(:ip, :ip_address),
          enabled: params.dig(:ip, :enabled)
        )
      end
    end
  end
end
