# frozen_string_literal: true

module Ips
  module Services
    class CreateIp < BaseService
      attr_reader :uuid

      def initialize(ip_address:, repo:, enabled:, logger:)
        @ip_address = ip_address
        @repo = repo
        @enabled = enabled
        @logger = logger
        @uuid = ''

        super
      end

      def self.call(ip_address:, repo: Repositories::Ip, enabled:, logger:)
        new(ip_address: ip_address, repo: repo, enabled: enabled, logger: logger).call
      end

      def call
        wrap do
          ip = @repo.find_by(address: @ip_address)
          raise IpAlreadyExistError, 'Ip address already exist.' unless ip.nil?

          @uuid = @repo.create(address: @ip_address, enabled: @enabled)
          @result = true
          self
        end
      end
    end
  end
end
