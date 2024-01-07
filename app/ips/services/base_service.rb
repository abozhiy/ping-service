# frozen_string_literal: true

module Ips
  module Services
    # Main base service
    class BaseService
      attr_reader :message, :result

      IpAlreadyExistError = Class.new StandardError
      IpNotExistError = Class.new StandardError

      def initialize(_attributes)
        @result = false
        @message = ''
      end

      def call
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def success?
        @result
      end

      private

      def params
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def validation
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end

      def validation_failure?
        return false unless validation.failure?

        @message = validation.errors.messages.first.text
        true
      end

      def wrap
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
