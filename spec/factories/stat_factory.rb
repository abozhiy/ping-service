# frozen_string_literal: true

FactoryBot.define do
  factory :stat, class: Entities::Stat do
    ip_id        { SecureRandom.uuid }
    rtt_min      { 11.111 }
    rtt_max      { 12.111 }
    rtt_avg      { 11.555 }
    rtt_stddev   { 3.555 }
    lost_packets { 0.1 }
    created_at   { Time.now }

    to_create do |stat|
      uuid = Ips::Repositories::Stat.create(
        ip_id: stat.ip_id,
        rtt_min: stat.rtt_min,
        rtt_max: stat.rtt_max,
        rtt_avg: stat.rtt_avg,
        rtt_stddev: stat.rtt_stddev,
        lost_packets: stat.lost_packets,
        created_at: stat.created_at
      )
      stat.id = uuid
    end
  end
end
