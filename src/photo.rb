class Photo
  WIDTH = 456
  HEIGHT = 408
  TILE = ENV["PHOTO_TILE_URL"]
  
  attr_reader :index, :filename
  
  def initialize(attrs)
    @index = attrs[:index]
    @filename = attrs[:filename]
  end
  
  def zoom_tile_offset
    @index * WIDTH / 2
  end
  
  def scaled_tile_offset
    @index * WIDTH / 4
  end
end