module PhotoNameMatcher
  def self.find_matching_photo(person, filenames)
    best_match = nil
    filenames.each do |filename|
      name = normalise filename.match(/([^\d]+).*\.\w+/).captures.first
      return filename if exact_match?(name, person)
      best_match = filename if surname_match?(name, person)
    end
    return best_match
  end
  
  def self.normalise(name)
    return "" unless name
    name.gsub(/[^a-zA-Z]/, '').downcase
  end
  
  def self.exact_match?(name, person)
    name.match normalise(person.name)
  end
  
  def self.surname_match?(name, person)
    initial = person.initial.downcase
    surname = normalise person.name.split(/\s/).last
    name.match /^#{initial}.*#{surname}$/
  end
end