# frozen_string_literal: true

module Ips
  module Services
    class DeleteIp
      IpNotExistError = Class.new StandardError

      def initialize(uuid:, repo:, logger:)
        @uuid = uuid
        @repo = repo
        @logger = logger
      end

      def self.call(uuid:, repo: Repositories::Ip, logger:)
        new(uuid: uuid, repo: repo, logger: logger).call
      end

      def call
        ip = @repo.find_by(id: @uuid)
        raise IpNotExistError if ip.nil?

        @repo.delete(@uuid)
      rescue StandardError => e
        @logger.error e.message
        nil
      end
    end
  end
end
