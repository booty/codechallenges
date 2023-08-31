def say_hello(name)
  puts "Hello, #{name}!"
end

def test_say_hello
  say_hello("World")
end

names = ["John", "Jane", "Joe"]
names.each do |name|
  say_hello(name)
end

# add four numbers together
# Path: copilot_experiments/add_four.rb
def add_four(a, b, c, d)
  a + b + c + d
end

# reverse a string and return it
# Path: copilot_experiments/reverse.rb
# reverse a string and return it
def reverse(str)
  str.reverse
end
