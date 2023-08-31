# frozen_string_literal: true

require_relative "common/testrunner"

# 35. Search Insert Position (Easy)
#
# Given a sorted array of distinct integers and a target value, return the index
# if the target is found. If not, return the index where it would be if it were
# inserted in order.
#
# You must write an algorithm with O(log n) runtime complexity.
#
# Example 1:
#
# Input: nums = [1,3,5,6], target = 5
# Output: 2
#
# Example 2:
#
# Input: nums = [1,3,5,6], target = 2
# Output: 1
#
# Example 3:
#
# Input: nums = [1,3,5,6], target = 7
# Output: 4

# Constraints:
#
#     1 <= nums.length <= 104
#     -10^4 <= nums[i] <= 10^4
#     nums contains distinct values sorted in ascending order.
#     -10^4 <= target <= 10^4
#

class Solutions
  # binary search
  def self.binary(nums, target)
    jump = nums.length / 2
    i = jump

    loop do
      n = nums[i]

      return i if n == target
      return 0 if i < 0
      return nums.length unless n

      if n > target && nums[i - 1] < target
        return i
      end

      jump = jump / 2
      jump = 1 if jump < 1

      if n > target
        i -= jump
      else
        i += jump
      end
    end
  end

  # works and is accepted, but this is O(n) instead of O(log n) as the
  # problem specifies
  def self.linear_search(nums, target)
    nums.each_with_index do |n, index|
      return index if n == target || n > target
    end
    nums.length
  end
end

test_cases = [
  {
    params: [[1, 3, 5, 6], 5],
    result: 2,
  },
  {
    params: [[1, 3, 5, 6], 2],
    result: 1,
  },
  {
    params: [[2, 3, 5, 6], 1],
    result: 0,
  },
  {
    params: [[1, 3, 5, 6], 7],
    result: 4,
  },
  {
    params: [(0..1_000_000).to_a, 999_999.1],
    result: 1000000,
    label: "pathological100k(end)",
  },
  {
    params: [(0..1_000_000).to_a, 50_000.1],
    result: 50001,
    label: "pathological100k(mid)",
  },
  {
    params: [(1..1_000_000).to_a, 0],
    result: 0,
    label: "pathological100k(start)",
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
