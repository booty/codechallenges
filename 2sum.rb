# frozen_string_literal: true

require_relative "testrunner"

shuffled_array_1k = (1..1000).to_a.shuffle
shuffled_array_10k = (1..10_000).to_a.shuffle
shuffled_array_100k = (1..100_000).to_a.shuffle
test_cases = [
  {
    params: [[3, 2, 4], 6],
    result: [1, 2],
    label: "3 elements unsorted",
  },
  {
    params: [[30, 5, 100, 99, 3], 33],
    result: [0, 4],
    label: "5 elements unsorted",
  },
  {
    params: [[1, 2], 3],
    result: [0, 1],
    label: "2 elements sorted",
  },
  {
    params: [[1, 2, 3, 4, 5, 6], 11],
    result: [4, 5],
    label: "6 elements sorted",
  },
  {
    params: [(1..1000).to_a, 1999],
    result: [998, 999],
    label: "1000 elements sorted",
  },
  {
    params: [(1..1000).to_a.reverse, 1999],
    result: [0, 1],
    label: "1000 elements reverse sorted",
  },
  {
    params: [shuffled_array_1k,3],
    result: [shuffled_array_1k.index(1), shuffled_array_1k.index(2)],
    label: "1000 elements shuffled",
  },
  {
    params: [shuffled_array_10k, 3],
    result: [shuffled_array_10k.index(1), shuffled_array_10k.index(2)],
    label: "10K elements shuffled",
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

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
)
