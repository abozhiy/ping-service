# frozen_string_literal: true

module Ips
  module Services
    class CreateIp
      IpAlreadyExistError = Class.new StandardError

      def initialize(ip_address:, repo:, enabled:, logger:)
        @ip_address = ip_address
        @repo = repo
        @enabled = enabled
        @logger = logger
      end

      def self.call(ip_address:, repo: Repositories::Ip, enabled:, logger:)
        new(ip_address: ip_address, repo: repo, enabled: enabled, logger: logger).call
      end

      def call
        ip = @repo.find_by(address: @ip_address)
        raise IpAlreadyExistError unless ip.nil?

        @repo.create(address: @ip_address, enabled: @enabled)
      rescue StandardError => e
        @logger.error e.message
        nil
      end
    end
  end
end
