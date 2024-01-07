# frozen_string_literal: true

module Ips
  module Services
    # Service allows to delete new IP rows
    class DeleteIp < BaseService
      def initialize(uuid:, logger:, repo:)
        @uuid = uuid
        @repo = repo
        @logger = logger

        super
      end

      def self.call(uuid:, logger:, repo: Repositories::Ip)
        new(uuid: uuid, logger: logger, repo: repo).call
      end

      def call
        wrap do
          ip = @repo.find_by(id: @uuid)
          raise IpNotExistError, 'Ip address does not exist.' if ip.nil?

          @repo.delete(@uuid)
          @result = true
          self
        end
      end
    end
  end
end
