class PhotoMatcher
  attr_reader :unused_filenames
  
  def initialize(filenames)
    @filenames = filenames.map(&:strip)
    @unused_filenames = @filenames.clone
  end
  
  def photo_for(person)
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
    @unused_filenames.delete best_match.filename if best_match
    return best_match
  end
  
  
  private
  
  def normalise(name)
    name.gsub(/[^a-zA-Z]/, '')
  end
  
  def name_from(filename)
    name_match = filename.match(/([^\d]+).*\.\w+/)
    name_match ? normalise(name_match.captures.first) : ''
  end
  
  def exact_match?(name, person)
    name.match /#{normalise person.name}/i
  end
  
  def surname_match?(name, person)
    surname = normalise person.name.split(/\s/).last
    name.match /^#{person.initial}.*#{surname}$/i
  end
end