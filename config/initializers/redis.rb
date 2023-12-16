# frozen_string_literal: true

REDIS_URL = "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/"
uri = URI.parse(REDIS_URL)
REDIS = Redis.new(host: uri.host, port: uri.port, password: uri.password)
