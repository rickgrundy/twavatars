class PhotoMatcher
  attr_reader :unused_photos, :duplicate_photos
  
  def initialize(filenames)
    @all_photos = filenames.map.with_index { |filename, i| Photo.new(filename: filename.strip, index: i) }
    @unused_photos = @all_photos.clone
    @duplicate_photos = []
  end
  
  def photo_for(person)
    all_matches = all_matches_for(person)
    best_match = all_matches.find { |photo| exact_match? name_from(photo), person } || all_matches.first
    track_usage(all_matches, best_match)
    best_match
  end
  
  
  private
  
  def all_matches_for(person)
    @all_photos.select { |photo| any_match? name_from(photo), person }
  end
  
  def normalise(name)
    name.gsub(/[^a-zA-Z]/, '')
  end
  
  def name_from(photo)
    name_match = photo.filename.match(/([^\d]+).*\.\w+/)
    name_match ? normalise(name_match.captures.first) : ''
  end
  
  def exact_match?(name, person)
    name.match /#{normalise person.name}/i
  end
  
  def surname_match?(name, person)
    surname = normalise person.name.split(/\s/).last
    name.match /^#{person.initial}.*#{surname}$/i
  end
  
  def any_match?(name, person)
    exact_match?(name, person) || surname_match?(name, person)
  end
  
  def track_usage(all_matches, best_match)
    @duplicate_photos += @unused_photos & all_matches
    @duplicate_photos.delete(best_match)
    @duplicate_photos.uniq!
    @unused_photos -= all_matches
  end
end