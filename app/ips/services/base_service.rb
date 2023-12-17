# frozen_string_literal: true

module Ips
  module Services
    class BaseService
      attr_reader :message, :result

      IpAlreadyExistError = Class.new StandardError
      IpNotExistError = Class.new StandardError

      def initialize(**attributes)
        @result = false
        @message = ''
      end

      def success?
        @result
      end

      private def wrap
        yield
      rescue StandardError => e
        @logger.error e
        @result = false
        @message = e.message
        self
      end
    end
  end
end
