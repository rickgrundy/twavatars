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
      photo = Person.new(photo_filename: "foo bar - 12345.jpg", photo_row: 1, photo_col: 2).photo
      photo.filename.should == "foo bar - 12345.jpg"
      photo.row.should == 1
      photo.col.should == 2
    end
  
    it 'assigns a photo' do
      person = Person.new
      person.photo = Photo.new(filename: "foo bar - 12345.jpg", row: 1, col: 2)
      person.photo_filename.should == "foo bar - 12345.jpg"
      person.photo_row.should == 1
      person.photo_col.should == 2
    end
  
    it 'unassigns a photo' do
      person = Person.new(photo_filename: "foo bar - 12345.jpg", photo_row: 1, photo_col: 2)
      person.photo = nil
      person.photo_filename.should == nil
      person.photo_row.should == nil
      person.photo_col.should == nil
    end
  end
end