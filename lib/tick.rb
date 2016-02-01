require_relative './sensors'
require_relative './models/measurement'
require_relative './models/humidifier'
require_relative './models/device'
module Shodan
  # Here will be runned all stuff to check temperature and turn on or off switches
  class Tick
    def initialize(sensors)
      @sensor = sensors
      run
    end

    def run
      puts "[Tick] !"
      @sensor.reset!
      if @sensor.temperature && @sensor.humidity
        puts "Current temperature: #{@sensor.temperature} C"
        puts "Current humidity: #{@sensor.humidity} %"
        measurement             = Measurement.new
        measurement.temperature = @sensor.temperature
        measurement.humidity    = @sensor.humidity
        measurement.save
      end
      Humidifier.all.each(&:tick!)
    end
  end
end
