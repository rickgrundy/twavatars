require 'mongoid'
require 'csv'
require_relative './photo.rb'
 
class Person
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  embeds_one :photo
  field :name, type: String
  field :phone, type: String
  field :location, type: String
  
  default_scope asc(:name)
  
  def self.missing_photos
    where(photo: nil)
  end
  
  def self.with_photos
    where(:photo.ne => nil)
  end
  
  def initial
    name[0].upcase
  end
end