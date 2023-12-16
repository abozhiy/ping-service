# frozen_string_literal: true

class Application < Sinatra::Base
  helpers Helpers::Validations


  configure do
    register Sinatra::Namespace

    logger = Logger.new("logs/#{ENV['RACK_ENV']}.log")
    set :logger, logger

    set :app_file, File.expand_path('../config.ru', __dir__)
  end

  configure :development do
    register Sinatra::Reloader

    set :show_exceptions, false
  end
end
