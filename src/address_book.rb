require 'csv'
require_relative './person.rb'

class AddressBook
  attr_reader :people  
  
  def initialize(csv)
    @people = []
    CSV.parse(csv, headers: true) do |row|
      if valid? row
        @people << Person.new(
          name: row["Name"], 
          phone: row["Mobile"], 
          location: row["Location"] || "Visitor"
        )
      end
    end
  end
  
  
  private
  
  def valid?(row)
    return false unless row["Name"] 
    return false if row["Name"] =~ /Access Card/i
    return false if @people.map { |p| p.name.downcase }.include? row["Name"].downcase
    true
  end
end