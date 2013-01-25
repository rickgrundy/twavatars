require "sinatra"
require "haml"

get '/' do
  @people = [{name: "Mr. Ted Long-Name Testersson", phone: "0777 777 777", avatar: "https://graph.facebook.com/rickgrundy/picture?type=large"}] * 10
  haml :index
end