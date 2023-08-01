# frozen_string_literal: true

require_relative "common/testrunner"

# Longest Common Subsequence Between Sorted Arrays (Medium)
#
# https://leetcode.com/problems/longest-common-subsequence-between-sorted-arrays/description/
#
# Given an array of integer arrays arrays where each arrays[i] is sorted in
# strictly increasing order, return an integer array representing the longest
# common subsequence between all the arrays.
#
# A subsequence is a sequence that can be derived from another sequence by
# deleting some elements (possibly none) without changing the order of the
# remaining elements.
#
# Example 1:
#
# Input: arrays = [[1,3,4], [1,4,7,9]]
# Output: [1,4]
# Explanation: The longest common subsequence in the two arrays is [1,4].
#
# Example 2:
#
# Input: arrays = [[2,3,6,8], [1,2,3,5,6,7,10], [2,3,4,6,9]]
# Output: [2,3,6]
# Explanation: The longest common subsequence in all three arrays is [2,3,6].
#
# Example 3:
#
# Input: arrays = [[1,2,3,4,5], [6,7,8]]
# Output: []
# Explanation: There is no common subsequence between the two arrays.
#
# Constraints:
#
#     2 <= arrays.length <= 100
#     1 <= arrays[i].length <= 100
#     1 <= arrays[i][j] <= 100
#     arrays[i] is sorted in strictly increasing order.

class Solutions
  def self.sets(arrays)
    result = nil
    arrays.each_with_index do |array, index|
      result = index.zero? ? array.to_set : (result & array.to_set)

      return [] if result.none?
    end
    result.to_a
  end

  # much faster than #histo
  def self.arrays(arrays)
    result = nil
    arrays.each_with_index do |array, index|
      result = index.zero? ? array : (result & array)

      return [] if result.none?
    end
    result
  end

  # well, I *thought* this was clever
  def self.histo(arrays)
    histo = Hash.new(0)

    arrays.each do |array|
      array.each do |element|
        histo[element] += 1
      end
    end

    histo.select { |_x, y| y == arrays.length }.keys
  end
end

test_cases = [
  {
    params: [[[1, 3, 4], [1, 4, 7, 9]]],
    result: [1, 4],
  },
  {
    params: [[[2, 3, 6, 8], [1, 2, 3, 5, 6, 7, 10], [2, 3, 4, 6, 9]]],
    result: [2, 3, 6],
  },
  {
    params: [[[1, 2, 3, 4, 5], [6, 7, 8]]],
    result: [],
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
  # label: "my friendly label",
)
