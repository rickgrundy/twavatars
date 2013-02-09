require 'mongoid'
require 'csv'
require_relative './photo.rb'
require_relative './photo_name_matcher.rb'
 
class Person
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  
  field :name, type: String
  field :phone, type: String
  field :location, type: String
  field :photo_filename, type: String
  field :photo_index, type: Integer
  
  def self.update_address_book(csv)
    self.destroy_all
    @used_names = []
    CSV.parse(csv, headers: true) do |row|
      if valid? row
        Person.new(name: row["Name"], phone: row["Mobile"], location: row["Location"] || "Visitor").save
        @used_names << row["Name"].downcase
      end
    end
  end
  
  def self.update_photos(filenames)
    photo_name_matcher = PhotoNameMatcher.new(filenames)
    Person.all.each do |person| 
      update_photo person, photo_name_matcher.find_matching_photo(person)
    end
    photo_name_matcher.unused_filenames
  end
  
  def self.missing_photos
    where(photo_index: nil).asc(:name)
  end
  
  def initial
    name[0].upcase
  end
  
  def photo
    Photo.new(index: photo_index, filename: photo_filename) if photo_index
  end
  
  private
  
  def self.valid?(row)
    row["Name"] && !(row["Name"] =~ /Access Card/) && !@used_names.include?(row["Name"].downcase)
  end
  
  def self.update_photo(person, photo)
    if photo
      person.photo_filename = photo.filename
      person.photo_index = photo.index
      person.save
    end
  end
end