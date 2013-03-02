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
    verify "FooBar", [0,0], "foo  bar .jpg"
    verify "Baz", [0,1], "BAZ.PNG"
  end
  
  it "ignores phone numbers" do
    create_matcher("foo1234.jpg", "bar - 1234.jpg", "baz 1234.jpg")
    verify "Foo", [0,0], "foo1234.jpg"
    verify "Bar", [0,1], "bar - 1234.jpg"
    verify "Baz", [1,0], "baz 1234.jpg"
  end
  
  it "matches on initial and surname" do
    create_matcher("FBar.jpg", "baz baz.jpg")
    verify "Foo Bar", [0,0], "FBar.jpg"
    verify "BaR Baz", [0,1], "baz baz.jpg"
  end
  
  it "prioritises exact matches over surname matches" do
    create_matcher("FBar.jpg", "foo bar.jpg", "f bar.jpg")
    verify "Foo Bar", [0,1], "foo bar.jpg"
  end
  
  it "tolerates reversed names and numbers" do
    create_matcher("012341234 - Foo Bar.jpg")
    verify "Foo Bar", [0,0], "012341234 - Foo Bar.jpg"
  end
  
  it "tolerates foreign characters as long as they match" do
    create_matcher("Føø.jpg", "Bar.jpg", "Båz.png")
    verify "Føø", [0,0], "Føø.jpg"
    verify_nil "Bår"
    verify_nil "Baz"
  end
  
  it "tolerates strange seperators" do
    create_matcher("Foo.Bar.jpg", "Hyphe-Nated.png")
    verify "Foo Bar", [0,0], "Foo.Bar.jpg"
    verify "H Nated", [0,1], "Hyphe-Nated.png"
  end
  
  it "ignores wildly unconventional formats" do
    create_matcher("Foo 1234 Bar.jpg", "1234.png", "Foo Bar")
    verify_nil "Foo Bar"
  end
  
  it "keeps track of unused filenames" do
    create_matcher("notused.jpg", "foo.jpg", "alsonotused.jpg")
    verify "Foo", [0,1], "foo.jpg"
    @matcher.unused_photos.map(&:filename).should == ["notused.jpg", "alsonotused.jpg"]
  end
  
  it "keeps track of duplicate images" do
    create_matcher("Person Foo.jpg", "notused.jpg", "Penguin Foo.jpg", "Parson Foo.jpg")
    verify "Person Foo", [0,0], "Person Foo.jpg"
    verify "Parson Foo", [1,1], "Parson Foo.jpg"
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

def verify(name, row_col, filename)
  photo = @matcher.photo_for Person.new(name: name)
  photo.filename.should == filename
  photo.row.should == row_col[0]
  photo.col.should == row_col[1]
end

def verify_nil(name)
  photo = @matcher.photo_for Person.new(name: name)
  photo.should be_nil
end