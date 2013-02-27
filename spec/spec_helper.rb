require 'rspec'
require 'mongoid'

Mongoid.load!("config/mongoid.yml", :test)