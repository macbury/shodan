require 'sinatra'
require 'thin'
require 'json'
require "sinatra/activerecord"
require_relative './tick'
require_relative './api'

module Shodan
  DEFAULT_PORT = 80
  SERVICE_TYPE = '_http._tcp'
  SERVICE_NAME = 'Shodan'
  # Run app
  def self.run(opts={})
    # Start he reactor
    EM.run do
      # define some defaults for our app
      server  = opts[:server] || 'thin'
      host    = opts[:host]   || '0.0.0.0'
      port    = opts[:port]   || DEFAULT_PORT
      web_app = opts[:app]    || Shodan::Api.new

      dispatch = Rack::Builder.app do
        map '/' do
          run web_app
        end
      end

      tr = DNSSD::TextRecord.new
      tr['description'] = SERVICE_NAME
      DNSSD.register(SERVICE_NAME, SERVICE_TYPE, 'local', port.to_i, tr.encode) do |reply|
        puts "Hello is anybody there?"
      end
      # NOTE that we have to use an EM-compatible web-server. There
      # might be more, but these are some that are currently available.
      unless ['thin', 'hatetepe', 'goliath'].include? server
        raise "Need an EM webserver, but #{server} isn't"
      end

      EM::Cron.schedule("* * * * *") do |time|
        puts "Reading sensor information: #{time}"
        Shodan::Tick.new
      end

      EM::Cron.schedule("0 17 * * 5") do |time|
        puts "Switching into weekend mode"
        Humidifier.all.each(&:weekend!)
      end

      EM::Cron.schedule("0 5 * * 1") do |time|
        puts "Switching into normal mode"
        Humidifier.all.each(&:check_env!)
      end

      # Start the web server. Note that you are free to run other tasks
      # within your EM instance.
      Rack::Server.start({
        app:    dispatch,
        server: server,
        Host:   host,
        Port:   port,
        signals: false,
      })
    end
  end

end
