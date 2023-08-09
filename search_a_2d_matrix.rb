# frozen_string_literal: true

require_relative "common/testrunner"

# 74. Search a 2D Matrix (Medium)
#
# You are given an m x n integer matrix matrix with the following two properties:
#
#     1. Each row is sorted in non-decreasing order.
#
#     2. The first integer of each row is greater than the last integer of
#        the previous row.
#
# Given an integer target, return true if target is in matrix or false otherwise.
#
# You must write a solution in O(log(m * n)) time complexity.
#
# Example 1:
#
# Input:
#   matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]],
#   target = 3
# Output: true
#
# Example 2:
#
# Input:
#   matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]],
#   target = 13
# Output: false
#
# Constraints:
#
#     m == matrix.length
#     n == matrix[i].length
#     1 <= m, n <= 100
#     -10^4 <= matrix[i][j], target <= 10^4
#

# assumes list is sorted
def binary_search(nums, target)
  left = 0
  right = nums.length - 1

  while left <= right
    i = ((left + right) / 2).floor
    val = nums[i]
    if val < target
      left = i + 1
    elsif val > target
      right = i - 1
    else
      return true
    end
  end
  false
end

def binary_2d_search(matrix, target)
  left = 0
  right = matrix.length - 1

  while left <= right
    i = ((left + right) / 2).floor
    nums = matrix[i]
    if target >= nums.first && target <= nums.last
      return matrix[i]
    elsif matrix[i].first < target
      left = i + 1
    else
      right = i - 1
    end
  end
  nil
end

class Solutions
  def self.binaryish(matrix, target)
    # binary search rows that might contain the answer
    nums = binary_2d_search(matrix, target)
    return false unless nums

    # binary search within the row
    binary_search(nums, target)
  end
end

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases: [
    {
      params: [[[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], 3],
      result: true,
      label: "number that exists",
    },
    {
      params: [[[1, 3, 5, 7], [10, 11, 16, 20], [23, 30, 34, 60]], 13],
      result: false,
      label: "number not found",
    },
  ],
)
