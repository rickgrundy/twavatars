require 'mongoid'
require 'csv'
require_relative './photo.rb'
require_relative './photo_name_matcher.rb'
 
class Person
  include Mongoid::Document
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
        row["Location"] ||= "Visitor"
        Person.new(name: row["Name"], phone: row["Mobile"], location: row["Location"]).save
        @used_names << row["Name"].downcase
      end
    end
  end
  
  def self.update_photos(filenames)
    filenames.map!(&:strip)
    Person.all.each do |person| 
      if matched = PhotoNameMatcher.find_matching_photo(person, filenames)
        person.photo_filename = matched[:filename]
        person.photo_index = matched[:index]
        person.save
      end
    end
  end
  
  def initial
    name[0].upcase
  end
  
  def photo
    Photo.new(index: photo_index) if photo_index
  end
  
  private
  
  def self.valid?(row)
    row["Name"] && !(row["Name"] =~ /Access Card/) && !@used_names.include?(row["Name"].downcase)
  end
end