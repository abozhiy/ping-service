# frozen_string_literal: true

module Ips
  module Services
    class DeleteIp < BaseService
      def initialize(uuid:, repo:, logger:)
        @uuid = uuid
        @repo = repo
        @logger = logger

        super
      end

      def self.call(uuid:, repo: Repositories::Ip, logger:)
        new(uuid: uuid, repo: repo, logger: logger).call
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
