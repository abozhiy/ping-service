# frozen_string_literal: true

DB = Sequel.connect(Settings.db.to_h).tap do |connection|
  connection.timezone = :utc
end
