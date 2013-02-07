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
  Person.update_address_book(params[:address_book][:tempfile].read) if params[:address_book]
  Person.update_photos(params[:photo_list][:tempfile].readlines) if params[:photo_list]
  redirect '/'
end

get '/' do
  @people = Person.all.asc(:name)
  haml :index
end

get "/twavatars.appcache" do
  ["CACHE MANIFEST", "", "CACHE:", "/", "/favicon.png", "/1140.css", "/style.css", "/app.js", Photo::TILE, 
    "http://themes.googleusercontent.com/static/fonts/robotocondensed/v7/Zd2E9abXLFGSr9G3YK2MsNxB8OB85xaNTJvVSB9YUjQ.woff",
    "", "NETWORK:", "*", "", "#VERSION #{appcache_version}"].join("\n")
end

private

def appcache_version
  Person.desc(:updated_at).first.updated_at.to_s + Photo::TILE
end