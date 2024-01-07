# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :db do
  task :seed, %i[version] => :settings do
    require 'sequel/core'

    Sequel.connect(Settings.db.to_h).tap do |db|
      dataset = db[:ips]
      %w[
        52.205.11.111
        52.4.55.112
        52.20.108.143
        52.201.131.218
        52.205.11.111
        52.60.48.246
        52.60.90.232
        13.244.48.162
        13.244.136.56
        52.66.94.141
        52.66.144.183
        52.62.56.25
        52.63.16.151
        52.198.43.67
        52.198.43.160
        52.78.158.117
        52.78.175.144
        52.67.38.171
        52.67.99.152
        15.161.196.95
        15.161.220.58
        52.56.51.140
        52.56.60.61
        142.251.208.110
        82.148.16.174
        13.244.48.162
        13.244.136.56
      ].each do |ip|
        next unless dataset.where(address: ip).first.nil?

        dataset.insert(address: ip, enabled: true)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
