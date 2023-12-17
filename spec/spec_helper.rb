# frozen_string_literal: false

require 'rack/test'
require 'factory_bot'
require 'database_cleaner-sequel'

module RSpecMixin
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      run Rack::URLMap.new('/ips' => ::Endpoints::Ips)
    end
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.include RSpecMixin

  config.include FactoryBot::Syntax::Methods
  config.before(:suite) { FactoryBot.find_definitions }

  DatabaseCleaner[:sequel].strategy = :transaction
  config.before(:each) do
    DatabaseCleaner[:sequel].start
  end
  config.after(:each) do
    DatabaseCleaner[:sequel].clean
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
