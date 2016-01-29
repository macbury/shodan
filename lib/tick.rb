require_relative './sensors'
require_relative './models/measurement'
require_relative './models/humidifier'
module Shodan
  # Here will be runned all stuff to check temperature and turn on or off switches
  class Tick
    def initialize
      run
    end

    def run
      temperature_and_hum = Shodan::Sensors.dht11
      if temperature_and_hum
        puts "Current temperature: #{temperature_and_hum[:temp]} C"
        puts "Current humidity: #{temperature_and_hum[:hum]} %"
        measurement             = Measurement.new
        measurement.temperature = temperature_and_hum[:temp]
        measurement.humidity    = temperature_and_hum[:hum]
        measurement.save
      end

      Humidifier.all.each(&:tick!)
    end
  end
end
