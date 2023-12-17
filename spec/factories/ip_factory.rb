# frozen_string_literal: true

FactoryBot.define do
  factory :ip, class: Entities::Ip do
    address { '127.0.0.1' }
    version { 'Ipv4' }
    enabled { true }

    to_create do |ip|
      uuid = Ips::Repositories::Ip.create(
        address: ip.address,
        version: ip.version,
        enabled: ip.enabled
      )
      ip.id = uuid
    end
  end
end
