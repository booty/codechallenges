# frozen_string_literal: true

require_relative "common/testrunner"

# Two Sum (Easy)
#
# https://leetcode.com/problems/two-sum/
#
# Given an array of integers nums and an integer target, return indices of the
# two numbers such that they add up to target.
#
# You may assume that each input would have exactly one solution, and you may
# not use the same element twice.
#
# You can return the answer in any order.
#
# Example 1:
#
# Input: nums = [2,7,11,15], target = 9
# Output: [0,1]
# Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
#
# Example 2:
#
# Input: nums = [3,2,4], target = 6
# Output: [1,2]
#
# Example 3:
#
# Input: nums = [3,3], target = 6
# Output: [0,1]
#
# Constraints:
#
# 2 <= nums.length <= 104
# -10^9 <= nums[i] <= 10^9
# -10^9 <= target <= 10^9
# Only one valid answer exists.

class Solutions
  def self.map(nums, target)
    map = {}

    nums.each_with_index do |n, i|
      # solution exists?
      complement = target - n
      return [i, map[complement]].sort if map[complement]

      # keep track of where we saw this
      map[n] = i
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
  # label: "my friendly label",
)
