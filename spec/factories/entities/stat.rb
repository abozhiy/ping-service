# frozen_string_literal: true

module Entities
  class Stat
    attr_accessor :id, :ip_id, :rtt_min, :rtt_max, :rtt_avg, :rtt_stddev, :lost_packets, :created_at
  end
end
