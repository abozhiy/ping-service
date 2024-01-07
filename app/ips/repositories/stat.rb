# frozen_string_literal: true

module Ips
  module Repositories
    # Stat repo
    class Stat
      class << self
        def create(**attributes)
          dataset.insert(attributes)
        end

        private

        def dataset
          DB[:stats]
        end
      end
    end
  end
end
