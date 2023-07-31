# frozen_string_literal: true

require_relative "testrunner"

# 259. 3Sum Smaller (Medium)
#
# https://leetcode.com/problems/3sum-smaller/description/
#
# Given an array of n integers nums and an integer target, find the number of
# index triplets i, j, k with 0 <= i < j < k < n that satisfy the condition
# nums[i] + nums[j] + nums[k] < target.
#
# Example 1:
#
# Input: nums = [-2,0,1,3], target = 2
# Output: 2
# Explanation: Because there are two triplets which sums are less than 2:
#   [-2,0,1]
#   [-2,0,3]
#
# Example 2:
#
# Input: nums = [], target = 0
# Output: 0
#
# Example 3:
#
# Input: nums = [0], target = 0
# Output: 0
#
# Constraints:
#
#     n == nums.length
#     0 <= n <= 3500
#     -100 <= nums[i] <= 100
#     -100 <= target <= 100

# def two_pointers(sorted_nums, target, start_index, end_index)
#   return 0 if target < 0

#   lpointer = start_index
#   rpointer = end_index

#   while lpointer < rpointer do
#   end
# end

def two_sum_smaller(sorted_nums:, target:, start_index:, end_index:)
  lpointer = start_index
  rpointer = end_index

  winners_temp = []
  winner_count = 0

  while rpointer > lpointer
    i = sorted_nums[lpointer]
    j = sorted_nums[rpointer]
    sum = i + j

    # putsif "lpointer:#{lpointer}(#{i}) rpointer:#{rpointer}(#{j}) sum:#{sum} winner_count:#{winner_count}"
    if sum >= target
      # putsif "  sum too big; we'll move rpointer"
      rpointer -= 1
    else
      winner_count += rpointer - lpointer
      # putsif "  success, there must be #{rpointer - lpointer} winners"
      lpointer += 1
    end
  end

  winner_count
end

class Solutions
  def self.first(nums, target)
    return 0 if nums.length < 3

    sorted_nums = nums.sort
    sorted_nums_length = sorted_nums.length
    winner_count = 0

    0.upto(sorted_nums_length - 3) do |i|
      n = sorted_nums[i]

      result = two_sum_smaller(
        sorted_nums:,
        target: target - n,
        start_index: i + 1,
        end_index: sorted_nums_length - 1,
      )

      return winner_count if result == 0

      winner_count += result
    end

    winner_count
  end
end

test_cases = [
  {
    params: [[0, -4, -1, 1, -1, 2], -5],
    result: 1,
  },
  {
    params: [[-2, 0, 1, 3], 2],
    result: 2,
  },
  {
    params: [[], 0],
    result: 0,
  },
  {
    params: [[0], 0],
    result: 0,
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
