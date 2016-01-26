# Here will be defined all api=
module Shodan
  class Api < Sinatra::Base
    configure do
      set :threaded, false
      set :database, { adapter: 'sqlite3' }
    end

    # Return current status for bamboo
    get '/' do
      content_type :json
      Measurement.last.to_json
    end

    # Return how much moisture is in bamboo
    get '/moisture' do
      content_type :json
      { moisture: 20 }.to_json
    end
  end
end
