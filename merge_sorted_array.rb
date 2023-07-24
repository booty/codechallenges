# frozen_string_literal: true

require_relative "testrunner"

# https://leetcode.com/problems/merge-sorted-array/description/
#
# You are given two integer arrays nums1 and nums2, sorted in non-decreasing order, and two
# integers m and n, representing the number of elements in nums1 and nums2 respectively.
#
# Merge nums1 and nums2 into a single array sorted in non-decreasing order.
#
# The final sorted array should not be returned by the function, but instead be stored inside
# the array nums1. To accommodate this, nums1 has a length of m + n, where the first m
# elements denote the elements that should be merged, and the last n elements are
# set to 0 and should be ignored. nums2 has a length of n.
#
# Example 1:
#
#    Input: nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3
#    Output: [1,2,2,3,5,6]
#    Explanation: The arrays we are merging are [1,2,3] and [2,5,6].
#    The result of the merge is [1,2,2,3,5,6] with the underlined elements coming from nums1.
#
# Example 2:
#
#    Input: nums1 = [1], m = 1, nums2 = [], n = 0
#    Output: [1]
#    Explanation: The arrays we are merging are [1] and [].
#    The result of the merge is [1].
#
# Example 3:
#
#    Input: nums1 = [0], m = 0, nums2 = [1], n = 1
#    Output: [1]
#    Explanation: The arrays we are merging are [] and [1].
#    The result of the merge is [1].
#    Note that because m = 0, there are no elements in nums1. The 0 is only there to ensure
#    the merge result can fit in nums1.
#
# Constraints:
#
#    nums1.length == m + n
#    nums2.length == n
#    0 <= m, n <= 200
#    1 <= m + n <= 200
#    -10^9 <= nums1[i], nums2[j] <= 10^9

class Solutions
  def self.backwards(nums1, m, nums2, n)
    write_pointer = (m + n) - 1
    nums1_read_pointer = m - 1
    nums2_read_pointer = n - 1

    while write_pointer >= 0
      nums1_val = nums1[nums1_read_pointer]
      nums2_val = nums2[nums2_read_pointer]

      # putsif "write_pointer:#{write_pointer} nums1_val:#{nums1_val}, nums2_val:#{nums2_val} nums1_read_pointer:#{nums1_read_pointer} nums2_read_pointer:#{nums2_read_pointer}"

      nums1[write_pointer] = if nums1_read_pointer == -1
                               nums2_read_pointer -= 1
                               nums2_val
                             elsif nums2_read_pointer == -1
                               nums1_read_pointer -= 1
                               nums1_val
                             elsif nums1_val > nums2_val
                               nums1_read_pointer -= 1
                               nums1_val
                             else
                               nums2_read_pointer -= 1
                               nums2_val
                             end

      write_pointer -= 1
    end

    nums1
  end
end

test_cases = [
  {
    params: [
      [1, 2, 3, 0, 0, 0].dup,
      3,
      [2, 5, 6],
      3,
    ],
    result: [1, 2, 2, 3, 5, 6],
  },
  {
    params: [
      [0].dup,
      0,
      [1],
      1,
    ],
    result: [1],
  },
  {
    params: [
      [1].dup,
      1,
      [],
      0,
    ],
    result: [1],
  },
  {
    params: [[2, 0].dup, 1, [1], 1],
    result: [1, 2],
  },
  {
    params: [[1, 2, 3, 0, 0, 0].dup, 3, [2, 5, 6], 3],
    result: [1, 2, 2, 3, 5, 6],
  },

]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
)
