# frozen_string_literal: true

require "benchmark/ips"

shuffled_array_1k = (1..1000).to_a.shuffle
shuffled_array_10k = (1..10_000).to_a.shuffle
shuffled_array_100k = (1..100_000).to_a.shuffle
test_cases = [
  {
    nums: [3, 2, 4],
    target: 6,
    result: [1, 2],
    name: "3 elements unsorted",
  },
  {
    nums: [30, 5, 100, 99, 3],
    target: 33,
    result: [0, 4],
    name: "5 elements unsorted",
  },
  {
    nums: [1, 2],
    target: 3,
    result: [0, 1],
    name: "2 elements sorted",
  },
  {
    nums: [1, 2, 3, 4, 5, 6],
    target: 11,
    result: [4, 5],
    name: "6 elements sorted",
  },
  {
    nums: (1..1000).to_a,
    target: 1999,
    result: [998, 999],
    name: "1000 elements sorted",
  },
  {
    nums: (1..1000).to_a.reverse,
    target: 1999,
    result: [0, 1],
    name: "1000 elements reverse sorted",
  },
  {
    nums: shuffled_array_1k,
    target: 3,
    result: [shuffled_array_1k.index(1), shuffled_array_1k.index(2)],
    name: "1000 elements shuffled",
  },
  {
    nums: shuffled_array_10k,
    target: 3,
    result: [shuffled_array_10k.index(1), shuffled_array_10k.index(2)],
    name: "10K elements shuffled",
  },
]

class Solutions
  def self.stolen_hash(nums, target)
    hash = {}
    nums.each_with_index do |number, index|
      return [hash[target - number], index] if hash[target - number]

      hash[number] = index
    end
  end

  def self.with_set(nums, target)
    nums_set = nums.to_set
    nums.each_with_index do |x, index|
      next unless nums_set.include?(target - x)

      index_b = nums.index(target - x)

      return [index, index_b] unless index_b == index
    end
  end

  def self.with_index(nums, target)
    nums.each_with_index do |x, index|
      index_b = nums.index(target - x)

      next if index_b.nil? || (index_b == index)

      return [index, index_b]
    end
  end
end

(Solutions.methods - Class.methods).each do |meth|
  puts meth
  test_cases.each_with_index do |tcase, tindex|
    puts "  case #{tindex} (#{tcase[:name]})"
    actual_result = Solutions.send(meth, tcase[:nums], tcase[:target])
    if actual_result.sort == tcase[:result].sort
      puts "    ✅ pass"
    else
      puts "    ❌ fail!"
      puts "    actual: #{actual_result}"
      puts "    expected: #{tcase[:result]}"
    end
  end
end

Benchmark.ips do |x|
  x.config(time: 1, warmup: 0.5)
  (Solutions.methods - Class.methods).each do |meth|
    test_cases.each_with_index do |tcase, tindex|
      actual_result = nil
      x.report("#{meth}: case #{tindex} (#{tcase[:name]})") do
        # puts "  case #{tindex}"
        actual_result = Solutions.send(meth, tcase[:nums], tcase[:target])
      end
    end
  end
end
