# Here will be defined all api=
module Shodan
  class Api < Sinatra::Base
    configure do
      set :threaded, false
      set :database, { adapter: 'sqlite3' }
    end

    get '/' do
      content_type :json
      Measurement.last.to_json
    end

    get '/stats/24_hours' do
      content_type :json
      Measurement.average_temperature_and_humidity_by_hour(24.hours.ago).to_json
    end

    get '/stats/last_week' do
      content_type :json
      Measurement.average_temperature_and_humidity_by_days(7.days.ago).to_json
    end
  end
end
