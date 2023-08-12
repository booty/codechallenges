# frozen_string_literal: true

require_relative "common/testrunner"

# 152. Maximum Product Subarray (Medium)
#
# https://leetcode.com/problems/maximum-product-subarray/
#
# Given an integer array nums, find a subarray that has the largest product, and
# return the product.
#
# The test cases are generated so that the answer will fit in a 32-bit integer.
#
# Example 1:
#
# Input: nums = [2,3,-2,4]
# Output: 6
# Explanation: [2,3] has the largest product 6.
#
# Example 2:
#
# Input: nums = [-2,0,-1]
# Output: 0
# Explanation: The result cannot be 2, because [-2,-1] is not a subarray.
#
# Constraints:
#
#     1 <= nums.length <= 2 * 10^4
#     -10 <= nums[i] <= 10
#     The product of any prefix or suffix of nums is
#       guaranteed to fit in a 32-bit integer.
#

class Solutions
  def self.brute(nums)
    highest = nil
    nums.each_with_index do |val1, index1|
      product = val1
      highest = product if highest.nil? || product > highest
      putsif "val1:#{val1} index1:#{index1} highest:#{highest}"
      (index1 + 1).upto(nums.length - 1) do |index2|
        product *= nums[index2]
        highest = product if highest.nil? || product > highest
        putsif "   product:#{product} nums[index2]:#{nums[index2]} index2:#{index2} highest:#{highest}"
      end
    end
    highest
  end
end

test_cases = [
  {
    params: [[2, 3, -2, 4]],
    result: 6,
  },
  {
    params: [[-2, 0, -1]],
    result: 0,
  },
  {
    params: [[-4, -3]],
    result: 12,
  }
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(actual_result, expected_result) {
  #   actual_result.to_set == expected_result.to_set
  # },
  # label: "my friendly label",
)
