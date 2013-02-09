require "sinatra"
require "haml"
require "mongoid"
configure :production do
  require 'newrelic_rpm'
end
  
require "./src/person"

Mongoid.load!("config/mongoid.yml")

get '/upload' do
  haml :upload
end

post '/upload' do
  if params[:address_book]
    Person.update_address_book(params[:address_book][:tempfile].read)
  end
  if params[:photo_list]
    @unmatched_photos = Person.update_photos(params[:photo_list][:tempfile].readlines)
  end
  @missing_photos = Person.missing_photos.map(&:name)
  haml :upload_finished
end

get '/' do
  @people = Person.asc(:name)
  haml :index
end

get "/twavatars.appcache" do
  return 404 if settings.environment == :development
  @version = appcache_version
  erb :appcache
end


private

def appcache_version
  Person.desc(:updated_at).first.updated_at.to_s + Photo::TILE
end