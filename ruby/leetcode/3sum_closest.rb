# frozen_string_literal: true

require_relative "common/testrunner"

# 16. 3Sum Closest
#
# https://leetcode.com/problems/3sum-closest/
#
# Given an integer array nums of length n and an integer target, find three
# integers in nums such that the sum is closest to target.
#
# Return the sum of the three integers.
#
# You may assume that each input would have exactly one solution.
#
# Example 1:
#
# Input: nums = [-1,2,1,-4], target = 1
# Output: 2
# Explanation: The sum that is closest to the target is 2. (-1 + 2 + 1 = 2).
#
# Example 2:
#
# Input: nums = [0,0,0], target = 1
# Output: 0
# Explanation: The sum that is closest to the target is 0. (0 + 0 + 0 = 0).
#
# Constraints:
#
#     3 <= nums.length <= 500
#     -1000 <= nums[i] <= 1000
#     -104 <= target <= 104

def two_sum_closest(sorted_nums, start_index, end_index, target)
  lpointer = start_index
  rpointer = end_index
  winner = nil
  winner_distance = nil

  while rpointer > lpointer
    candidate = [sorted_nums[lpointer], sorted_nums[rpointer]]
    candidate_sum = candidate.sum
    distance = (target - candidate_sum).abs

    return candidate if distance == 0

    if candidate_sum < target
      lpointer += 1
    else
      rpointer -= 1
    end

    if winner.nil? || (distance < winner_distance)
      winner = candidate
      winner_distance = distance
    end
  end

  winner
end

class Solutions
  def self.sorted_nums(nums, target)
    sorted_nums = nums.sort
    sorted_nums_length = sorted_nums.length
    winner = nil
    winner_distance = nil
    max_index = sorted_nums_length - 3

    # make a single pass through sorted_nums
    # for each n in sorted_nums, pass the remainder
    # of the list to #two_sum_closest
    # keep track of the current "winning" trio
    # if a trio exactly matches the target we can return
    # early
    sorted_nums.each_with_index do |num, index|
      distance = target - num

      others = if index == max_index
                 [sorted_nums[index + 1], sorted_nums[index + 2]]
               elsif index < max_index
                 two_sum_closest(sorted_nums, index + 1, sorted_nums.length - 1, distance)
               end

      next unless others

      candidate = [num, others[0], others[1]]
      candidate_sum = candidate.sum
      return candidate_sum if candidate_sum == target

      candidate_distance = (target - candidate_sum).abs

      if winner.nil? || (candidate_distance < winner_distance)
        winner = candidate
        winner_distance = candidate_distance
      end
    end

    winner.sum
  end
end

test_cases = [
  {
    params: [[-1, 2, 1, -4], 1],
    result: 2,
  },
  {
    params: [[0, 0, 0], 1],
    result: 0,
  },
  {
    # correct triplet is [-5, 0, 3]
    params: [[4, 0, 5, -5, 3, 3, 0, -4, -5], -2],
    result: -2,
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
  # label: "my friendly label",
)
