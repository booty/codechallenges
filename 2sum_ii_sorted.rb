# frozen_string_literal: true

require_relative "testrunner"

# 167. Two Sum II - Input Array Is Sorted (Medium)
#
# https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/
#
# Given a 1-indexed array of integers numbers that is already sorted in
# non-decreasing order, find two numbers such that they add up to a specific
# target number. Let these two numbers be numbers[index1] and numbers[index2]
# where 1 <= index1 < index2 < numbers.length.
#
# Return the indices of the two numbers, index1 and index2, added by one as an
# integer array [index1, index2] of length 2.
#
# The tests are generated such that there is exactly one solution. You may not use
# the same element twice.
#
# Your solution must use only constant extra space.
#
# Example 1:
#
# Input: numbers = [2,7,11,15], target = 9
# Output: [1,2]
# Explanation: The sum of 2 and 7 is 9. Therefore, index1 = 1, index2 = 2.
#              We return [1, 2].
#
# Example 2:
#
# Input: numbers = [2,3,4], target = 6
# Output: [1,3]
# Explanation: The sum of 2 and 4 is 6. Therefore index1 = 1, index2 = 3.
#              We return [1, 3].
#
# Example 3:
#
# Input: numbers = [-1,0], target = -1
# Output: [1,2]
# Explanation: The sum of -1 and 0 is -1. Therefore index1 = 1, index2 = 2.
#             We return [1, 2].
#
# Constraints:
#
#     2 <= numbers.length <= 3 * 104 -1000 <= numbers[i] <= 1000 numbers is sorted
#     in non-decreasing order. -1000 <= target <= 1000 The tests are generated
#     such that there is exactly one solution.

class Solutions
  # Borrowed from 2sum_revenge.rb
  # This is not ideal because we're not taking advantage of the fact that nums
  # is sorted. The "two pointers" approach below is also O(n) but does not
  # require additional storage for the hash map
  def self.map(nums, target)
    map = {}

    nums.each_with_index do |num, idx|
      complement = target - num
      if map[complement]
        # binding.pry
        return [idx + 1, map[complement] + 1].sort
      end

      map[num] = idx
    end
  end

  # requires no additional storage
  # can greatly outperform #map for large arrays
  def self.two_pointers(numbers, target)
    left_pointer = 0
    right_pointer = numbers.length - 1

    while left_pointer < right_pointer
      sum = numbers[left_pointer] + numbers[right_pointer]

      if sum == target
        return [left_pointer + 1, right_pointer + 1]
      elsif sum < target
        left_pointer += 1
      else
        right_pointer -= 1
      end
    end
  end
end

test_cases = [
  {
    params: [[2, 7, 11, 15], 9],
    result: [1, 2],
  },
  {
    params: [[2, 3, 4], 6],
    result: [1, 3],
  },
  {
    params: [[-1, 0], -1],
    result: [1, 2],
  },
  {
    params: [[-1, 0], -1],
    result: [1, 2],
  },
  {
    # pathologically bad for #two_pointers as we must traverse the entire array
    params: [(100_000..200_000).to_a + [400_000, 400_001] + (900_000..1_000_000).to_a, 800_001],
    result: [100002, 100003],
    silent: true,
    label: "pathologic bad for two_pointers",
  },
  {
    # pathologically good for #two_pointers as we find the answer instantly
    # pathologically bad for #map because it must traverse the entire array
    params: [[1] + (1_000_000..2_000_000).to_a + [100_000_000], 100_000_001],
    result: [1, 1000003],
    silent: true,
    label: "pathologic good for two_pointers",
  },
  {
    # pathologically good for #because we find the answer instantly
    # pathologically bad for #two_pointers because it must traverse the entire array
    params: [[1, 2] + (1_000_000..2_000_000).to_a, 3],
    result: [1, 2],
    silent: true,
    label: "pathologic good for map",
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(actual_result, expected_result) {
  #   actual_result.to_set == expected_result.to_set
  # },
  # label: "my friendly label",
)
