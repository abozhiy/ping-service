# frozen_string_literal: true

module Ips
  module Services
    module SwitchStat
      class Enable < Base
        private def update_enabled_field
          @repo.update(@uuid, enabled: true)
        end
      end
    end
  end
end
