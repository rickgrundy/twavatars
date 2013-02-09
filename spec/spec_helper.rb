require 'rspec'
require 'mongoid'

ENV["PHOTO_TILE_URL"] = "http://testing/avatars.jpg"

Mongoid.load!("config/mongoid.yml", :test)