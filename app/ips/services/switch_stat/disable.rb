# frozen_string_literal: true

module Ips
  module Services
    module SwitchStat
      # Service allows to disable statistic collector for IP
      class Disable < Base
        private

        def update_enabled_field
          @repo.update(@uuid, enabled: false)
        end
      end
    end
  end
end
