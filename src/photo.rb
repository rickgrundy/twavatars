class Photo
  WIDTH = 456
  HEIGHT = 408
  TILE = ENV["PHOTO_TILE_URL"]
  COLS = ENV["PHOTO_TILE_COLS"].to_i
  
  attr_reader :row, :col, :filename
  
  def initialize(attrs)
    @filename = attrs[:filename]
    @row, @col = attrs[:row], attrs[:col]
  end
  
  def zoom_tile_offset
    {x: @col * WIDTH/2, y: @row * HEIGHT/2}
  end
  
  def scaled_tile_offset
    {x: @col * WIDTH/4, y: @row * HEIGHT/4}
  end
end