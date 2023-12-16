# frozen_string_literal: true

namespace :db do
  task :create do
    `createdb -U postgres -h localhost ping_dev`
    `createdb -U postgres -h localhost ping_test`
  end
end
