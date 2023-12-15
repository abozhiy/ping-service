# frozen_string_literal: false

ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

require_relative 'root'
require_relative 'application_loader'
ApplicationLoader.load_app!
