require 'spec_helper'
require_relative '../src/person'
require_relative '../src/photo'

describe Person do
  it 'provides an initial letter' do
    Person.new(name: "foo bar").initial.should == "F"
  end

  describe 'with photo' do
    it 'provides a photo if one exists' do
      Person.new.photo.should be_nil
      photo = Person.new(photo_filename: "foo bar - 12345.jpg", photo_index: 12).photo
      photo.filename.should == "foo bar - 12345.jpg"
      photo.index.should == 12
    end
  
    it 'assigns a photo' do
      person = Person.new
      person.photo = Photo.new(filename: "foo bar - 12345.jpg", index: 6)
      person.photo_filename.should == "foo bar - 12345.jpg"
      person.photo_index.should == 6
    end
  
    it 'unassigns a photo' do
      person = Person.new(photo_filename: "foo bar - 12345.jpg", photo_index: 12)
      person.photo = nil
      person.photo_filename.should == nil
      person.photo_index.should == nil
    end
  end
end