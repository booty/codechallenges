# frozen_string_literal: true

require_relative "testrunner"

# 27. Remove Element (Easy)
#
# https://leetcode.com/problems/remove-element/description/
#
# Given an integer array nums and an integer val, remove all occurrences of val in
# nums in-place. The order of the elements may be changed. Then return the number
# of elements in nums which are not equal to val.
#
# Consider the number of elements in nums which are not equal to val be k, to get
# accepted, you need to do the following things:
#
#     Change the array nums such that the first k elements of nums contain the
#     elements which are not equal to val. The remaining elements of nums are not
#     important as well as the size of nums. Return k.
#
# Custom Judge:
#
# The judge will test your solution with the following code:
#
# int[] nums = [...]; // Input array int val = ...; // Value to remove int
# [] expectedNums = [...]; // The expected answer with correct length.
#                             // It is sorted with no values equaling val.
#
# int k = removeElement(nums, val); // Calls your implementation
#
# assert k == expectedNums.length; sort(nums, 0, k); // Sort the first k elements
# of nums for (int i = 0; i < actualLength; i++) { assert nums[i] == expectedNums
# [i]; }
#
# If all assertions pass, then your solution will be accepted.
#
# Example 1:
#
# Input: nums = [3,2,2,3], val = 3
# Output: 2, nums = [2,2,_,_]
# Explanation: Your function should return k = 2, with the first two
# elements of nums being 2. It does not matter what you leave beyond the
# returned k (hence they are underscores).
#
# Example 2:
#
# Input: nums = [0,1,2,2,3,0,4,2], val = 2 Output: 5, nums =
# [0,1,4,0,3,_,_,_] Explanation: Your function should return k = 5, with the
# first five elements of nums containing 0, 0, 1, 3, and 4. Note that the five
# elements can be returned in any order. It does not matter what you leave beyond
# the returned k (hence they are underscores).
#
# Constraints:
#
#     0 <= nums.length <= 100
#     0 <= nums[i] <= 50
#     0 <= val <= 100

class Solutions
  def self.two_pointers(nums, val)
    write_pointer = 0
    0.upto(nums.length - 1) do |read_pointer|
      x = nums[read_pointer]
      if x != val
        nums[write_pointer] = x
        write_pointer += 1
      end
    end
    write_pointer
  end

  def self.sloppy(nums, val)
    nums.sort! { |x| x == val ? 1 : 0 }
    nums.count { |x| val != x }
  end
end

test_cases = [
  {
    params: -> { [[3, 2, 2, 3], 3] },
    label: "4 elements",
    result: 2,
  },
  {
    params:
      -> { [[0, 1, 2, 2, 3, 0, 4, 2], 2] },
    label: "8 elements",
    result: 5,
  },
  {
    params:
      -> {
        [[4, 2, 10, 1, 7, 7, 1, 2, 10, 4, 5, 7, 4, 3, 7, 8, 4, 8, 9, 2, 10, 3, 7, 5, 10, 6, 3, 1, 8, 1, 2, 4, 3, 4, 8, 7, 7, 10, 9, 3, 1, 10, 9, 5, 9, 10, 4, 10, 3, 2],
         5]
      },
    label: "50 elements",
    result: 47,
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
