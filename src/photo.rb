class Photo
  WIDTH = 456
  HEIGHT = 408
  TILE = ENV["PHOTO_TILE_URL"] || raise("Must set PHOTO_TILE_URL env var.")
  
  def initialize(attrs)
    @index = attrs[:index]
  end
  
  def zoom_tile_offset
    @index * WIDTH / 2
  end
  
  def scaled_tile_offset
    @index * WIDTH / 4
  end
end