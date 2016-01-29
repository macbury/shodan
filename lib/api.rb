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

    get '/humidifier/:id/refill' do
      content_type :json
      Humidifier.find(params[:id]).refill!
      sleep 3
      { success: true }.to_json
    end

    get '/stats' do
      content_type :json

      humidifier = Humidifier.first
      {
        current: Measurement.last,
        humidifier: { id: humidifier.id, left: humidifier.shot_left, total: humidifier.max_shots, state: humidifier.state, min_humidity: humidifier.min_humidity, next_update_in: humidifier.next_tick_seconds_left },
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
