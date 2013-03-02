require 'spec_helper'
require_relative '../src/person'
require_relative '../src/photo'

describe Person do
  it 'provides an initial letter' do
    Person.new(name: "foo bar").initial.should == "F"
  end
end