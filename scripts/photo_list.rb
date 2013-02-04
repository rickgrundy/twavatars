ask = ->(prompt){ puts prompt; gets.strip }

dir = ask['Photos directory:']

File.open('photos.txt', 'w') do |txt| 
  Dir["#{dir}/*"].map { |f| txt << File.basename(f) + "\n" }
end