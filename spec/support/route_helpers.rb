# frozen_string_literal: false

module RouteHelpers
  def app
    described_class
  end

  def responce_body
    JSON(last_response.body)
  end
end
