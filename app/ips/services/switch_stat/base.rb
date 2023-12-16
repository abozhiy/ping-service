# frozen_string_literal: true

module Ips
  module Services
    module SwitchStat
      class Base
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

          update_enabled_field
          @uuid
        rescue StandardError => e
          @logger.error e.message
          nil
        end

        private def update_enabled_field
          raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
        end
      end
    end
  end
end
