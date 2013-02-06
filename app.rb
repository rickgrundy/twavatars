require "sinatra"
require "haml"
require "mongoid"

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