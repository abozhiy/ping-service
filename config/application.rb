# frozen_string_literal: true

class Application < Sinatra::Base # rubocop:disable Style/Documentation
  helpers Helpers::Validations

  configure do
    register Sinatra::Namespace

    log_file = File.open(File.join(APP_ROOT, "/logs/#{ENV['RACK_ENV']}.log"), 'a')
    logger = Logger.new(log_file)
    set :logger, logger

    set :app_file, File.expand_path('../config.ru', __dir__)
  end

  configure :development do
    register Sinatra::Reloader

    set :show_exceptions, false
  end
end
