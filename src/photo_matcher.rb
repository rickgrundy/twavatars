class PhotoMatcher
  attr_reader :unused_photos, :duplicate_photos
  
  def initialize(photo_txt_lines)
    @all_photos = photo_txt_lines.map.with_index do |line, i|
      coord, filename = line.split("\s", 2)
      row, col = coord.split(",").map(&:to_i)
      Photo.new(filename: filename.strip, row: row, col: col)
    end
    @unused_photos = @all_photos.clone
    @duplicate_photos = []
  end
  
  def photo_for(person)
    all_matches = all_matches_for(person)
    best_match = all_matches.find { |photo| exact_match? photo, person } || all_matches.first
    track_usage(all_matches, best_match)
    best_match
  end
  
  
  private
  
  def all_matches_for(person)
    @all_photos.select { |photo| any_match? photo, person }
  end
  
  def normalise(name)
    name.gsub(/[^a-zA-Z]/, '')
  end
  
  def name_from(photo)
    name_match = photo.filename.match(/([^\d]+).*\.\w+/)
    name_match ? normalise(name_match.captures.first) : ''
  end
  
  def exact_match?(photo, person)
    name_from(photo).match /#{normalise person.name}/i
  end
  
  def surname_match?(photo, person)
    surname = normalise person.name.split(/\s/).last
    name_from(photo).match /^#{person.initial}.*#{surname}$/i
  end
  
  def any_match?(photo, person)
    exact_match?(photo, person) || surname_match?(photo, person)
  end
  
  def track_usage(all_matches, best_match)
    @duplicate_photos += @unused_photos & all_matches
    @duplicate_photos.delete(best_match)
    @unused_photos -= all_matches
  end
end