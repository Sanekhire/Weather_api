# frozen_string_literal: true

set :environment, 'development'
set :output, 'log/cron.log'

every :hour do
  runner 'Weather.load_data'
end
