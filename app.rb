require "sinatra"
require "haml"
require "mongoid"
configure :production do
  require 'newrelic_rpm'
end
  
require "./src/person"
require "./src/photo"
require "./src/address_book"
require "./src/photo_matcher"

Mongoid.load!("config/mongoid.yml")

raise("Must set PHOTO_TILE_URL and PHOTO_TILE_COLS env vars.") unless Photo::TILE and Photo::COLS

get '/upload' do
  haml :upload
end

post '/upload' do
  update_address_book if params[:address_book]
  update_photos if params[:photo_list]
  @with_photos = Person.with_photos
  @missing_photos = Person.missing_photos
  haml :upload_finished
end

get '/' do
  @people = Person.with_photos
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
  book = AddressBook.new as_utf8(params[:address_book][:tempfile].read)
  book.people.each &:save
end

def update_photos
  matcher = PhotoMatcher.new params[:photo_list][:tempfile].readlines.map { |l| as_utf8(l) }
  Person.each do |person|
    person.photo = matcher.photo_for person
    person.save
  end
  @unused_photos = matcher.unused_photos
  @duplicate_photos = matcher.duplicate_photos
end

def as_utf8(str)
  str.encode 'UTF-8', {:invalid => :replace, :undef => :replace, :replace => ''}
end