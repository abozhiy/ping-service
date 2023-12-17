# frozen_string_literal: true

module Ips
  module Services
    class Ping
      TIMEOUT= 2
      COUNT = 5

      def initialize(ip:, timeout:, count:)
        @ip = ip
        @timeout = timeout
        @count = count
      end

      def self.call(ip:, timeout: TIMEOUT, count: COUNT)
        new(ip: ip, timeout: timeout, count: count).call
      end

      def call
        `ping -t #{@timeout} -c #{@count} #{@ip}`
      end
    end
  end
end
