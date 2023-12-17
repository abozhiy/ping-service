# Ping-service
IP address availability monitoring system.

## Usage:

Sinatra

Sequel (Postgresql)

ruby 3.2.2

### Install gems:
bundle install

### DB:
Create DB: 'rake db:create'

Drop DB: 'rake db:drop'

Migrates: 'rake db:migrate', 'RACK_ENV=test rake db:migrate'

Seeds: 'rake db:seed'

### Start server:
bin/puma

### Run console:
bin/console

### Run sidkiq:
bin/sidekiq
