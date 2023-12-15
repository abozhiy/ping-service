# frozen_string_literal: true

# module to load app
module ApplicationLoader
  extend self

  def load_app!
    init_config
    init_db
    require_app
    init_app
  end

  private

  def require_app
    require_dir 'app/helpers'
    require_file 'config/application'
    require_dir 'app'
  end

  def init_app
    require_dir 'config/initializers'
  end

  def init_config
    require_dir 'config/initializers/config'
  end

  def init_db
    require_dir 'config/initializers/sequel'
  end

  def require_file(path)
    require File.join(APP_ROOT, path)
  end

  def require_dir(path)
    path = File.join(APP_ROOT, path)
    Dir["#{path}/**/*.rb"]
      .sort
      .each { |file| require file }
  end
end
