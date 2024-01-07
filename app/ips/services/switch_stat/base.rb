# frozen_string_literal: true

module Ips
  module Services
    module SwitchStat
      # Base service for enable/disable statistic collector for IP
      class Base < BaseService
        attr_reader :uuid

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

            update_enabled_field
            @result = true
            self
          end
        end

        private

        def update_enabled_field
          raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
        end
      end
    end
  end
end
