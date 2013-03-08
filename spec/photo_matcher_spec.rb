# encoding: UTF-8

require 'spec_helper'
require_relative '../src/photo_matcher'
require_relative '../src/person'

describe PhotoMatcher do
  it "returns nil if no match" do
    create_matcher("nope.png")
    verify_nil "Someone Else"
  end
  
  it "ignores whitespace and case" do
    create_matcher(" foo  bar .jpg", "BAZ.PNG")
    verify "FooBar", "foo  bar .jpg", 0, 0
    verify "Baz", "BAZ.PNG", 0, 1
  end
  
  it "ignores phone numbers" do
    create_matcher("foo1234.jpg", "bar - 1234.jpg", "baz 1234.jpg")
    verify "Foo", "foo1234.jpg", 0, 0
    verify "Bar", "bar - 1234.jpg", 0, 1
    verify "Baz", "baz 1234.jpg", 1, 0
  end
  
  it "matches on initial and surname" do
    create_matcher("FBar.jpg", "baz baz.jpg")
    verify "Foo Bar", "FBar.jpg", 0, 0
    verify "BaR Baz", "baz baz.jpg", 0, 1
  end
  
  it "prioritises exact matches over surname matches" do
    create_matcher("FBar.jpg", "foo bar.jpg", "f bar.jpg")
    verify "Foo Bar", "foo bar.jpg", 0, 1
  end
  
  it "tolerates reversed names and numbers" do
    create_matcher("012341234 - Foo Bar.jpg")
    verify "Foo Bar", "012341234 - Foo Bar.jpg", 0, 0
  end
  
  it "tolerates foreign characters as long as they match" do
    create_matcher("Føø.jpg", "Bar.jpg", "Båz.png")
    verify "Føø", "Føø.jpg", 0, 0
    verify_nil "Bår"
    verify_nil "Baz"
  end  
  
  it "tolerates strange seperators" do
    create_matcher("Foo.Bar.jpg", "Hyphe-Nated.png")
    verify "Foo Bar", "Foo.Bar.jpg", 0, 0
    verify "H Nated", "Hyphe-Nated.png", 0, 1
  end
  
  it "ignores wildly unconventional formats" do
    create_matcher("Foo 1234 Bar.jpg", "1234.png", "Foo Bar")
    verify_nil "Foo Bar"
  end
  
  it "keeps track of unused filenames" do
    create_matcher("notused.jpg", "foo.jpg", "alsonotused.jpg")
    verify "Foo", "foo.jpg", 0, 1
    @matcher.unused_photos.map(&:filename).should == ["notused.jpg", "alsonotused.jpg"]
  end
  
  it "keeps track of duplicate images" do
    create_matcher("Person Foo.jpg", "notused.jpg", "Penguin Foo.jpg", "Parson Foo.jpg")
    verify "Person Foo", "Person Foo.jpg", 0, 0
    verify "Parson Foo", "Parson Foo.jpg", 1, 1
    @matcher.duplicate_photos.map(&:filename).should == ["Penguin Foo.jpg"]
  end
end

def create_matcher(*files)
  cols = *(0...Math.sqrt(files.size).ceil)
  rows = *(0...Math.sqrt(files.size).round)
  coords = rows.product(cols)
  lines = coords.zip(files).map{ |coord, f| "#{coord.join(',')} #{f}" if f}.compact
  @matcher = PhotoMatcher.new(lines)
end

def verify(name, filename, row, col)
  photo = @matcher.photo_for Person.new(name: name)
  photo.filename.should == filename
  photo.row.should == row
  photo.col.should == col
end

def verify_nil(name)
  photo = @matcher.photo_for Person.new(name: name)
  photo.should be_nil
end