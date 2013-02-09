require 'spec_helper'
require_relative '../src/photo'

describe Photo do
  it 'calculates the offset along a photo tile at 25% scale' do
    Photo.new(index: 0).scaled_tile_offset.should == 0
    Photo.new(index: 1).scaled_tile_offset.should == Photo::WIDTH * 0.25
    Photo.new(index: 2).scaled_tile_offset.should == Photo::WIDTH * 0.5
  end
  
  it 'calculates the offset along a photo tile at 50% scale' do
    Photo.new(index: 0).zoom_tile_offset.should == 0
    Photo.new(index: 1).zoom_tile_offset.should == Photo::WIDTH * 0.5
    Photo.new(index: 2).zoom_tile_offset.should == Photo::WIDTH * 1.0
  end
end