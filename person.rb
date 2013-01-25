require 'mongoid'
require 'csv'
 
class Person
  include Mongoid::Document
  field :name, type: String
  field :phone, type: String
  field :location, type: String
  
  def self.update_address_book(csv)
    self.destroy_all
    @used_names = []
    CSV.parse(csv, headers: true) do |row|
      if valid? row
        row["Location"] ||= "Visitor"
        Person.new(name: row["Name"], phone: row["Mobile"], location: row["Location"]).save
        @used_names << row["Name"].downcase
      end
    end
  end
  
  def avatar
    "https://graph.facebook.com/#{name.gsub(' ', '').downcase}/picture?type=large"
  end
  
  private
  
  def self.valid?(row)
    row["Name"] && !(row["Name"] =~ /Access Card/) && !@used_names.include?(row["Name"].downcase)
  end
end