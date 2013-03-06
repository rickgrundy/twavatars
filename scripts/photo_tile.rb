require 'fileutils'
require 'RMagick'
require_relative '../src/photo.rb'

ask = ->(prompt){ puts prompt; gets.strip }

W = Photo::WIDTH
H = Photo::HEIGHT

output_dir = FileUtils.mkdir_p('tmp').first
photos_dir = ENV['PHOTOS_DIR'] || ask['Photos directory:']

files = Dir["#{photos_dir}/*.{jpg,jpeg,png,JPG,JPEG,PNG}"]

cols = *(0...Math.sqrt(files.size).ceil)
rows = *(0...Math.sqrt(files.size).round)

File.open("#{output_dir}/photos.txt", 'w') do |txt|
  coords = rows.product(cols)
  files.each do |f|
    txt.puts "#{coords.shift.join(",")} #{File.basename(f)}"
  end
end

tiles = Magick::ImageList.new *files
tiles.each do |i|
  i.resize! W, H 
  i.auto_orient!
end
montage = tiles.montage do
  self.border_width = 0
  self.geometry = Magick::Geometry.new W, H, 0, 0
  self.tile = Magick::Geometry.new cols.size, rows.size
end
montage.write("#{output_dir}/avatars.jpg") { self.quality = 50 }

puts "--> Finished. Upload #{output_dir}/avatars.jpg to the CDN and #{output_dir}/photos.txt to the app."
puts "--> You will also need to run this command: heroku config:set PHOTO_TILE_COLS=#{cols.size}"