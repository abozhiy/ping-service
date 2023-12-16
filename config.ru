# frozen_string_literal: false

require_relative 'config/environment'

Sidekiq::Web.use Rack::Session::Cookie, secret: ENV['SESSION_SECRET']
run Rack::URLMap.new(
  '/ips' => ::Endpoints::Ips,
  '/sidekiq' => Sidekiq::Web
)
