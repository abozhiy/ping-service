# frozen_string_literal: true

module Services
  class CreateIp
    IpAlreadyExistError = Class.new StandardError

    def initialize(ip_address:, enabled:)
      @ip_address = ip_address
      @enabled = enabled
    end

    def self.call(ip_address:, enabled:)
      new(ip_address: ip_address, enabled: enabled).call
    end

    def call
      ip = repo.find_by(address: @ip_address)
      raise IpAlreadyExistError unless ip.nil?

      repo.create(address: @ip_address, enabled: @enabled)
    end

    private

    def repo
      @repo ||= ::Repositories::Ip
    end
  end
end
