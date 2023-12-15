# frozen_string_literal = true

module Helpers
  module Validations
    InvalidParamsError = Class.new StandardError

    def validate_with!(validation)
      contract = validation.new
      params = JSON.parse(request.body.read)
      result = contract.call(params)
      raise InvalidParamsError if result.failure?

      result
    end
  end
end
