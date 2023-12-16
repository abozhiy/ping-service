# frozen_string_literal: true

namespace :db do
  task :drop do
    `dropdb -U postgres -h localhost ping_dev`
    `dropdb -U postgres -h localhost ping_test`
  end
end
