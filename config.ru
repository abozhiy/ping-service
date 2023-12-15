# frozen_string_literal: false

require_relative 'config/environment'

map '/ips' do
  run ::Endpoints::Ips
end
