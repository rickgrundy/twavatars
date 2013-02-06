require 'fileutils'
require 'RMagick'
require_relative '../src/photo.rb'

ask = ->(prompt){ puts prompt; gets.strip }

W = Photo::WIDTH
H = Photo::HEIGHT

output_dir = FileUtils.mkdir_p('tmp').first
photos_dir = ask['Photos directory:']
photos_dir = "/Users/rick/avatars" if photos_dir.empty?

files = Dir["#{photos_dir}/*.{jpg,jpeg,png,JPG,JPEG,PNG}"]

File.open("#{output_dir}/photos.txt", 'w') do |txt| 
  txt.puts files.map { |f| File.basename f }
end

tiles = Magick::ImageList.new *files
tiles.each { |i| i.resize! W, H }
montage = tiles.montage do
  self.border_width = 0
  self.geometry = Magick::Geometry.new W, H, 0, 0
  self.tile = Magick::Geometry.new tiles.size, 1
end
montage.write("#{output_dir}/avatars.jpg") { self.quality = 35 }

puts "--> Finished. Upload #{output_dir}/avatars.jpg to the CDN and #{output_dir}/photos.txt to the app."