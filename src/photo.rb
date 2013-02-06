class Photo
  WIDTH = 456
  HEIGHT = 408
  
  def initialize(attrs)
    @index = attrs[:index]
  end
  
  def tile_url
    ENV["PHOTO_TILE_URL"] || raise("Must specify PHOTO_TILE_URL env var.")
  end
  
  def tile_offset
    @index * WIDTH / 4 # Scale down for retina
  end
end