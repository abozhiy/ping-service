# frozen_string_literal: true

module Contracts
  class IpParamsContract < Dry::Validation::Contract
    params do
      required(:ip).hash do
        required(:enabled).filled(:bool)
        required(:ip_address).filled(:string)
      end
    end
  end
end
