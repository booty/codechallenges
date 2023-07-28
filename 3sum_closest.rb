# frozen_string_literal: true

require_relative "testrunner"

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

def two_sum_closest(sorted_nums, target)
  lpointer = 0
  rpointer = sorted_nums.length - 1
  winner = nil
  winner_distance = nil

  while rpointer > lpointer
    candidate = [sorted_nums[lpointer], sorted_nums[rpointer]]
    distance = target - candidate.sum

    puts "lpointer:#{lpointer} rpointer:#{rpointer} candidate:#{candidate} distance:#{distance} winner:#{winner} winner_distance:#{winner_distance}"

    return candidate if distance == 0

    # if the distance is positive (candidate too small)
    # move the left pointer
    if distance.positive?
      lpointer += 1
    else
      rpointer -= 1
    end

    if winner.nil? || (distance.abs < winner_distance.abs)
      winner = candidate
      winner_distance = distance
    end
  end

  winner
end


class Solutions
  def self.sorted(nums, target)
    sorted = nums.sorted

    # make a single pass through sorted
    # for each n in sorted, pass the remainder
    # of the list to #two_sum_closest
    # keep track of the current "winning" trio
    # if a trio exactly matches the target we can return
    # early
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
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
  # label: "my friendly label",
)
