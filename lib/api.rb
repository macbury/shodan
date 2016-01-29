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

    get '/stats' do
      content_type :json
      {
        current: Measurement.last,
        humidifiers: Humidifier.all.map { |h| { id: h.id, left: h.shot_left, state: h.state, min_humidity: h.min_humidity } },
        last_24: Measurement.average_temperature_and_humidity_by_hour(24.hours.ago),
        last_week: Measurement.average_temperature_and_humidity_by_days(7.days.ago)
      }.to_json
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
