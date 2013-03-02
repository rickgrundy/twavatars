class Photo
  include Mongoid::Document
  
  WIDTH = 456
  HEIGHT = 408
  TILE = ENV["PHOTO_TILE_URL"]
  COLS = ENV["PHOTO_TILE_COLS"].to_i
  
  embedded_in :person
  field :filename, type: String
  field :row, type: Integer
  field :col, type: Integer
  
  def zoom_tile_offset
    {x: col * WIDTH/2, y: row * HEIGHT/2}
  end
  
  def scaled_tile_offset
    {x: col * WIDTH/4, y: row * HEIGHT/4}
  end
end