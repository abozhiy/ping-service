# frozen_string_literal: true

module Contracts
  class IpParamsContract < Dry::Validation::Contract
    params do
      required(:ip).hash do
        required(:enabled).filled(:bool)
        required(:ip_address).filled(:string)
      end
    end

    rule(:ip) do
      unless /((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}/i.match?(value[:ip_address])
        key.failure('Ip address has invalid format')
      end
    end
  end
end
