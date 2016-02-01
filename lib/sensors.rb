require 'cocaine'

module Shodan

  # This module helps with interacting with sensors
  class Sensors
    DEFAULT_DHT11_PIN = 4
    DHT_RESULT_REGEXP = /Temp=([\d\.]+).+Humidity=([\d\.]+)/i

    def initialize
      @sample_times = 0
      @total_temperature = 0.0
      @total_humidity    = 0.0

      try_again!
    end

    def reset!
      @avg_temperature   = @total_temperature / [@sample_times, 1].max
      @avg_humidity      = @total_humidity / [@sample_times, 1].max

      puts "Current avg temperature #{@avg_temperature}"
      puts "Current avg humidity #{@avg_humidity}"

      @sample_times = 0
      @total_temperature = 0.0
      @total_humidity    = 0.0
    end

    def temperature
      @avg_temperature
    end

    def humidity
      @avg_humidity
    end

    def try_again!
      operation = proc { read }
      callback  = proc { EM.add_timer(1) { try_again! } }
      EM.defer(operation, callback)
    end

    # Reads temperature and humidity from dht11 sensor
    # @return hum is in percent and temp is in celcius
    def self.dht11(pin=DEFAULT_DHT11_PIN)
      query = Cocaine::CommandLine.new('sudo /usr/local/bin/dht', "11 #{pin}")
      puts "Running: #{query.command}"
      result = query.run
      if result =~ DHT_RESULT_REGEXP
        return [$1.to_f, $2.to_f]
      else
        return [0.0,0.0]
      end
    end

    # Reads avg temperature and humidity from dht11 sensor
    def read
      @sample_times += 1
      temperature, humidity = Shodan::Sensors.dht11
      @total_temperature += temperature
      @total_humidity    += humidity
    end
  end

end
