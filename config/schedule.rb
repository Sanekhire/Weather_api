# frozen_string_literal: true
set :environment, "development"
set :output, "log/cron.log"

every :hour do
    rake "tables_data:update_forecasts"
end
