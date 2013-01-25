require "sinatra"
require "haml"
require "mongoid"

require "./person"

Mongoid.load!("config/mongoid.yml")

get '/upload' do
  haml :upload
end

post '/upload' do
  Person.update_address_book(params[:address_book][:tempfile].read)
  redirect '/'
end

get '/' do
  @people = Person.all
  haml :index
end