class PhotoNameMatcher
  
  def initialize(filenames)
    @filenames = filenames.map(&:strip)
    @used_filenames = []
  end
  
  def find_matching_photo(person)
    best_match = nil
    @filenames.each_with_index do |filename, i|
      if exact_match? name_from(filename), person
        best_match = Photo.new(filename: filename, index: i)
        break
      end
      if surname_match? name_from(filename), person
        best_match = Photo.new(filename: filename, index: i)
      end
    end
    @used_filenames << best_match.filename if best_match
    return best_match
  end
  
  def unused_filenames
    @filenames - @used_filenames
  end
  
  private
  
  def normalise(name)
    return "" unless name
    name.gsub(/[^a-zA-Z]/, '').downcase
  end
  
  def name_from(filename)
    normalise filename.match(/([^\d]+).*\.\w+/).captures.first
  end
  
  def exact_match?(name, person)
    name.match normalise(person.name)
  end
  
  def surname_match?(name, person)
    initial = person.initial.downcase
    surname = normalise person.name.split(/\s/).last
    name.match /^#{initial}.*#{surname}$/
  end
end