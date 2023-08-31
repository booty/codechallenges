# frozen_string_literal: true

require_relative "common/testrunner"

# https://leetcode.com/problems/two-sum/description/
#
# Given an array of integers nums and an integer target, return indices of
# the two numbers such that they add up to target.
#
# You may assume that each input would have exactly one solution, and you may
# not use the same element twice.
#
# You can return the answer in any order.
#
# Example 1:
#
#   Input: nums = [2,7,11,15], target = 9
#   Output: [0,1]
#   Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
#
# Example 2:
#
#   Input: nums = [3,2,4], target = 6
#   Output: [1,2]
#
# Example 3:
#
#   Input: nums = [3,3], target = 6
#   Output: [0,1]
#
# Constraints:
#
#     2 <= nums.length <= 104
#     -109 <= nums[i] <= 109
#     -109 <= target <= 109
#     Only one valid answer exists.
#

class Solutions
  def self.map(nums, target)
    map = Array.new(nums.length)

    nums.each_with_index do |num, i|
      if (target - num).positive? && map[target - num]
        # binding.pry
        return [i, map[target - num]]
      end

      map[num] = i
    end
  end

  # should be O(n) time?
  def self.hashmap(nums, target)
    map = {}

    nums.each_with_index do |num, i|
      if map[target - num]
        return [i, map[target - num]]
      end

      map[num] = i
    end
  end

  # obviously O(n^2) / 2ish, just wanted a baseline for fun
  def self.brute(nums, target)
    left = 0
    len = nums.length
    until left == len - 1
      (left + 1).upto(len - 1) do |right|
        if nums[left] + nums[right] == target
          return [left, right]
        end
      end
      left += 1
    end
  end
end

shuffled_array_1k = (1..1000).to_a.shuffle
shuffled_array_10k = (1..10_000).to_a.shuffle
test_cases = [
  {
    params: [[3, 2, 4], 6],
    result: [1, 2],
  },
  {
    params: [[3, 3], 6],
    result: [0, 1],
  },
  {
    params: [[3, 2, 4], 6],
    result: [1, 2],
  },
  {
    params: [(1..1000).to_a, 1999],
    result: [998, 999],
    label: "1-1000",
    silent: true,
  },
  {
    params: [shuffled_array_1k, 3],
    result: [shuffled_array_1k.index(1), shuffled_array_1k.index(2)],
    label: "1K shuffled",
  },
  {
    params: [shuffled_array_10k, 3],
    result: [shuffled_array_10k.index(1), shuffled_array_10k.index(2)],
    label: "10K shuffled",
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  custom_comparison: ->(a, b) { a.to_set == b.to_set },
)
