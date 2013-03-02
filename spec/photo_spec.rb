require 'spec_helper'
require_relative '../src/photo'

describe Photo do
  it 'calculates the offset along a photo tile at 25% scale' do
    Photo.new(row: 0, col: 0).scaled_tile_offset.should == {x: 0, y: 0}
    Photo.new(row: 1, col: 1).scaled_tile_offset.should == {x: Photo::WIDTH * 0.25, y: Photo::HEIGHT * 0.25}
    Photo.new(row: 2, col: 2).scaled_tile_offset.should == {x: Photo::WIDTH * 0.50, y: Photo::HEIGHT * 0.50}
    Photo.new(row: 1, col: 2).scaled_tile_offset.should == {x: Photo::WIDTH * 0.50, y: Photo::HEIGHT * 0.25}
  end
  
  it 'calculates the offset along a photo tile at 50% scale' do
    Photo.new(row: 0, col: 0).zoom_tile_offset.should == {x: 0, y: 0}
    Photo.new(row: 1, col: 1).zoom_tile_offset.should == {x: Photo::WIDTH * 0.5, y: Photo::HEIGHT * 0.5}
    Photo.new(row: 2, col: 2).zoom_tile_offset.should == {x: Photo::WIDTH * 1.0, y: Photo::HEIGHT * 1.0}
    Photo.new(row: 1, col: 2).zoom_tile_offset.should == {x: Photo::WIDTH * 1.0, y: Photo::HEIGHT * 0.5}
  end
end