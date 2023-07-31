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
    candidate_sum = candidate.sum
    distance = (target - candidate_sum).abs

    # putsif "target:#{target} lpointer:#{lpointer} rpointer:#{rpointer} candidate:#{candidate} " \
    #      "candidate_sum:#{candidate_sum} distance:#{distance} winner:#{winner} " \
    #      "winner_distance:#{winner_distance}"

    return candidate if distance == 0

    # if the distance is positive (candidate too small)
    # move the left pointer
    if candidate_sum < target
      lpointer += 1
      # putsif "  moving lpointer"
    else
      rpointer -= 1
      # putsif "  moving rpointer"
    end

    if winner.nil? || (distance < winner_distance)
      # putsif "  new winner"
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

    # putsif "----- start #{sorted_nums} -----"

    temp_reps = 0
    # make a single pass through sorted_nums
    # for each n in sorted_nums, pass the remainder
    # of the list to #two_sum_closest
    # keep track of the current "winning" trio
    # if a trio exactly matches the target we can return
    # early
    sorted_nums.each_with_index do |num, index|
      distance = target - num

      # putsif "  index:#{index} num:#{num} distance:#{distance}"

      others = if index == (sorted_nums_length - 3)
                 [sorted_nums[index + 1], sorted_nums[index + 2]]
               elsif index < sorted_nums_length - 3
                 slice = sorted_nums[index + 1..]
                 # putsif "    passing to two_sum slice:#{slice}"
                 two_sum_closest(slice, distance)
               end

      next unless others

      candidate = [num] + others
      candidate_distance = (target - candidate.sum).abs
      # putsif "    candidate:#{candidate} candidate_distance:#{candidate_distance}"

      if winner.nil? || (candidate_distance.abs < winner_distance.abs)
        winner = candidate
        winner_distance = candidate_distance
      end
    end

    # putsif "----- end (winner:#{winner} winner.sum:#{winner.sum} -----"
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
