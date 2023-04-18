# frozen_string_literal: true

require "benchmark/ips"
require "pry-byebug"

test_cases = [
  {
    nums: [1, 0, -1, 0, -2, 2],
    target: 0,
    output: [[-2, -1, 1, 2], [-2, 0, 0, 2], [-1, 0, 0, 1]],
  },
  {
    nums: [2, 2, 2, 2, 2],
    target: 8,
    output: [[2, 2, 2, 2]],
  },
  {
    nums: [-493, -482, -482, -456, -427, -405, -392, -385, -351, -269, -259, -251, -235, -235, -202, -201, -194, -189, -187, -186, -180,
           -177, -175, -156, -150, -147, -140, -122, -112, -112, -105, -98, -49, -38, -35, -34, -18, 20, 52, 53, 57, 76, 124, 126, 128, 132, 142, 147, 157, 180, 207, 227, 274, 296, 311, 334, 336, 337, 339, 349, 354, 363, 372, 378, 383, 413, 431, 471, 474, 481, 492],
    target: 6189,
    output: [],
  },
]

class Solutions
  def self.naive(nums, target)
    results = Set.new
    nums.permutation(4) do |perm|
      results << perm.sort if perm.sum == target
    end
    results
  end
end

(Solutions.methods - Class.methods).each do |meth|
  puts meth
  test_cases.each do |tcase|
    puts "  target:#{tcase[:target]} nums:#{tcase[:nums]}"

    actual_output = Solutions.
      send(meth, tcase[:nums], tcase[:target]).
      each(&:sort!).
      sort
    expected_output = tcase[:output].
      each(&:sort!).
      sort

    if actual_output == expected_output
      puts "    ✅ pass (#{actual_output})"
    else
      puts "    ❌ fail!"
      puts "    actual: #{actual_output}"
      puts "    expected: #{expected_output}"
    end
  end
end
