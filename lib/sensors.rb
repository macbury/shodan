require 'cocaine'

module Shodan

  # This module helps with interacting with sensors
  module Sensors
    DEFAULT_DHT11_PIN = 4
    DHT_RESULT_REGEXP = /temp = ([\d]+).+Hum = ([\d]+)/i

    # Reads temperature and humidity from dht11 sensor
    # @return { hum: 0, temp: 0 } hum is in percent and temp is in celcius
    def self.dht11(pin=DEFAULT_DHT11_PIN)
      tries = 8
      while tries > 0
        result = Cocaine::CommandLine.new('dht', "11 #{pin}").run
        if result =~ DHT_RESULT_REGEXP

          return { hum: $2.to_i, temp: $1.to_i }
        else
          tries -= 1
          sleep 2
        end
      end
      return false
    end
  end

end
