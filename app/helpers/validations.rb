# frozen_string_literal = true

module Helpers
  module Validations
    InvalidParamsError = Class.new StandardError

    def validate_with(klass)
      contract = klass.new
      body = request.body.read
      body = request.params if body.empty?
      params = valid_json?(body) ? JSON.parse(body) : body
      contract.call(params)
    end

    def valid_json?(string)
      !!JSON.parse(string)
    rescue JSON::ParserError, StandardError
      false
    end
  end
end
