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
  field :photo_row, type: Integer
  field :photo_col, type: Integer
  
  default_scope asc(:name)
  
  def self.missing_photos
    where(photo_filename: nil)
  end
  
  def self.with_photos
    where(:photo_filename.ne => nil)
  end
  
  def initial
    name[0].upcase
  end
  
  def photo
    Photo.new(filename: photo_filename, row: photo_row, col: photo_col) if photo_filename
  end
  
  def photo=(photo)
    self.photo_filename, self.photo_row, self.photo_col = photo ? [photo.filename, photo.row, photo.col] : nil
  end
end