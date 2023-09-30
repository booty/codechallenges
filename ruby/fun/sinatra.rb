require "sinatra"

get "/" do
  "Hello, world!"
end

get "/secretinfo" do
  "you found it"
end

get "/recipes" do
  "you want to COOK?"
end

get "/foo" do
  erb :foo
end
