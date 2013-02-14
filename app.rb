require "sinatra"
require "haml"
require "mongoid"
configure :production do
  require 'newrelic_rpm'
end
  
require "./src/person"
require "./src/address_book"
require "./src/photo_matcher"

Mongoid.load!("config/mongoid.yml")

get '/upload' do
  haml :upload
end

post '/upload' do
  update_address_book if params[:address_book]
  update_photos if params[:photo_list]
  @missing_photos = Person.missing_photos.map(&:name)
  haml :upload_finished
end

get '/' do
  @people = Person.all
  haml :index
end

get "/twavatars.appcache" do
  return 404 if settings.environment == :development
  @version = appcache_version
  erb :appcache
end


private

def appcache_version
  Person.where(:updated_at.exists => true).desc(:updated_at).first.updated_at.to_s + " " + Photo::TILE
end

def update_address_book
  Person.destroy_all
  book = AddressBook.new params[:address_book][:tempfile].read
  book.people.each &:save
end

def update_photos
  matcher = PhotoMatcher.new params[:photo_list][:tempfile].readlines
  Person.each do |person|
    person.photo = matcher.photo_for person
    person.save
  end
  @unmatched_photos = matcher.unused_filenames
end