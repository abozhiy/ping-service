# frozen_string_literal: true

module Services
  class DeleteIp
    IpNotExistError = Class.new StandardError

    def initialize(uuid:)
      @uuid = uuid
    end

    def self.call(uuid:)
      new(uuid: uuid).call
    end

    def call
      ip = repo.find_by(id: @uuid)
      raise IpNotExistError if ip.nil?

      repo.delete(@uuid)
    end

    private

    def repo
      @repo ||= ::Repositories::Ip
    end
  end
end
