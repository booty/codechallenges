# frozen_string_literal: true

require_relative "common/testrunner"

# Given an integer array nums and an integer k, return true if there are
# two distinct indices i and j in the array such that  nums[i] == nums[j]
# and abs(i - j) <= k.
#
# Example 1:
#
# Input: nums = [1,2,3,1], k = 3
# Output: true
#
# Example 2:
#
# Input: nums = [1,0,1,1], k = 1
# Output: true
#
# Example 3:
#
# Input: nums = [1,2,3,1,2,3], k = 2
# Output: false
#
# Constraints:
#
#     1 <= nums.length <= 10^5
#     -10^9 <= nums[i] <= 10^9
#     0 <= k <= 10^5

class Solutions
  # O(n) time, passes (space: O(min(n,k))
  def self.naiveish(nums, k)
    map = {}

    nums.each_with_index do |n, idx|
      return true if map[n] && idx - map[n] <= k

      map[n] = idx
    end

    false
  end
end

test_cases = [
  {
    params: [[1, 2, 3, 1], 3],
    result: true,
  },
  {
    params: [[1, 0, 1, 1], 1],
    result: true,
  },
  {
    params: [[1, 2, 3, 1, 2, 3], 2],
    result: false,
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
  # label: "my friendly label",
)
