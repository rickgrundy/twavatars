require 'mongoid'
require 'csv'
require_relative './photo.rb'
 
class Person
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  
  field :name, type: String
  field :phone, type: String
  field :location, type: String
  field :photo_filename, type: String
  field :photo_index, type: Integer
  
  default_scope asc(:name)
  
  def self.missing_photos
    where(photo_index: nil)
  end
  
  def self.with_photos
    where(:photo_index.ne => nil)
  end
  
  def initial
    name[0].upcase
  end
  
  def photo
    Photo.new(index: photo_index, filename: photo_filename) if photo_index
  end
  
  def photo=(photo)
    self.photo_filename, self.photo_index = photo ? [photo.filename, photo.index] : [nil, nil]
  end
end