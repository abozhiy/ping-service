# frozen_string_literal: true

module Contracts
  class IpStatParamsContract < Dry::Validation::Contract # rubocop:disable Style/Documentation
    params do
      required(:time_from).filled(:date_time)
      required(:time_to).filled(:date_time)
    end
  end
end
