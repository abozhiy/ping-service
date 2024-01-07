# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq-cron'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/0" }

  schedule_file = './config/schedule.yml'
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if File.exist?(schedule_file)
end
