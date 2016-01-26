require 'bundler'
Bundler.require
require 'sinatra/activerecord/rake'


namespace :db do
  task :load_config do
    require "./lib/api"
  end
end


task :tick do
  require "./lib/tick"
  Shodan::Tick.new
end
