require 'spec_helper'
require_relative '../src/address_book'

describe AddressBook do
  it "extracts name, number and location" do
    book = AddressBook.new csv("Foo Bar,0222222222,Sydney", "Someone Else,0333333333,Melbourne")
    book.should have(2).people
    book.people.first.name.should == "Foo Bar"
    book.people.first.phone.should == "0222222222"
    book.people.first.location.should == "Sydney"
  end
  
  it "assumes people are visiting if location is missing" do
    book = AddressBook.new csv("Foo Bar,0222222222,")
    book.people.first.location.should == "Visitor"
  end
  
  it "ignores access cards" do
    book = AddressBook.new csv("Access card - Syd,,")
    book.should have(0).people
  end
  
  it "ignores missing names" do
    book = AddressBook.new csv(",0222222222,Sydney")
    book.should have(0).people
  end
  
  it "ignores duplicate names" do
    book = AddressBook.new csv("Foo Bar,0222222222,Sydney", "foo bar,0333333333,Melbourne")
    book.should have(1).person  
  end
end

def csv(*people)
  (["Name,Mobile,Location"] + people).join "\n"
end