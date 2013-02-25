# encoding: UTF-8

require 'spec_helper'
require_relative '../src/photo_matcher'
require_relative '../src/person'

describe PhotoMatcher do
  it "returns nil if no match" do
    @matcher = PhotoMatcher.new ["nope.png"]
    verify_nil "Someone Else"
  end
  
  it "ignores whitespace and case" do
    @matcher = PhotoMatcher.new [" foo  bar .jpg", "BAZ.PNG"]
    verify "FooBar", 0, "foo  bar .jpg"
    verify "Baz", 1, "BAZ.PNG"
  end
  
  it "ignores phone numbers" do
    @matcher = PhotoMatcher.new ["foo1234.jpg", "bar - 1234.jpg", "baz 1234.jpg"]
    verify "Foo", 0, "foo1234.jpg"
    verify "Bar", 1, "bar - 1234.jpg"
    verify "Baz", 2, "baz 1234.jpg"
  end
  
  it "matches on initial and surname" do
    @matcher = PhotoMatcher.new ["FBar.jpg", "baz baz.jpg"]
    verify "Foo Bar", 0, "FBar.jpg"
    verify "BaR Baz", 1, "baz baz.jpg"
  end
  
  it "prioritises exact matches over surname matches" do
    @matcher = PhotoMatcher.new ["FBar.jpg", "foo bar.jpg", "f bar.jpg"]
    verify "Foo Bar", 1, "foo bar.jpg"
  end
  
  it "tolerates reversed names and numbers" do
    @matcher = PhotoMatcher.new ["012341234 - Foo Bar.jpg"]
    verify "Foo Bar", 0, "012341234 - Foo Bar.jpg"
  end
  
  it "tolerates foreign characters as long as they match" do
    @matcher = PhotoMatcher.new ["Føø.jpg", "Bar.jpg", "Båz.png"]
    verify "Føø", 0, "Føø.jpg"
    verify_nil "Bår"
    verify_nil "Baz"
  end
  
  it "tolerates strange seperators" do
    @matcher = PhotoMatcher.new ["Foo.Bar.jpg", "Hyphe-Nated.png"]
    verify "Foo Bar", 0, "Foo.Bar.jpg"
    verify "H Nated", 1, "Hyphe-Nated.png"
  end
  
  it "ignores wildly unconventional formats" do
    @matcher = PhotoMatcher.new ["Foo 1234 Bar.jpg", "1234.png", "Foo Bar"]
    verify_nil "Foo Bar"
  end
  
  it "keeps track of unused filenames" do
    @matcher = PhotoMatcher.new ["notused.jpg", "foo.jpg", "alsonotused.jpg"]
    verify "Foo", 1, "foo.jpg"
    @matcher.unused_photos.map(&:filename).should == ["notused.jpg", "alsonotused.jpg"]
  end
  
  it "keeps track of duplicate images" do
    @matcher = PhotoMatcher.new ["Person Foo.jpg", "notused.jpg", "Penguin Foo.jpg", "Parson Foo.jpg"]
    verify "Person Foo", 0, "Person Foo.jpg"
    verify "Parson Foo", 3, "Parson Foo.jpg"
    @matcher.duplicate_photos.map(&:filename).should == ["Penguin Foo.jpg"]
  end
end

def verify(name, index, filename)
  photo = @matcher.photo_for Person.new(name: name)
  photo.filename.should == filename
  photo.index.should == index
end

def verify_nil(name)
  photo = @matcher.photo_for Person.new(name: name)
  photo.should be_nil
end