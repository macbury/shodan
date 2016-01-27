require 'cocaine'

module Shodan

  # This module helps with interacting with sensors
  module Sensors
    DEFAULT_DHT11_PIN = 4
    DHT_RESULT_REGEXP = /Temp=([\d\.]+).+Humidity=([\d\.]+)/i

    # Reads temperature and humidity from dht11 sensor
    # @return { hum: 0, temp: 0 } hum is in percent and temp is in celcius
    def self.dht11(pin=DEFAULT_DHT11_PIN)
      query = Cocaine::CommandLine.new('sudo /usr/local/bin/dht', "11 #{pin}")
      puts "Running: #{query.command}"
      result = query.run
      if result =~ DHT_RESULT_REGEXP
        return { hum: $2.to_f, temp: $1.to_f }
      else
        return false
      end
    end
  end

end
