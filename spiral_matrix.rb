# frozen_string_literal: true

require_relative "common/testrunner"

# 54. Spiral Matrix (Medium)
#
# https://leetcode.com/problems/spiral-matrix/
#
# Given an m x n matrix, return all elements of the matrix in spiral order.
#
# Example 1:
#
# Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
# Output: [1,2,3,6,9,8,7,4,5]
#
# Example 2:
#
# Input: matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
# Output: [1,2,3,4,8,12,11,10,9,5,6,7]
#
# Constraints:
#
#     m == matrix.length
#     n == matrix[i].length
#     1 <= m, n <= 10
#     -100 <= matrix[i][j] <= 100

class Solutions
  def self.turtle(matrix)
    result = []
    heading = :right
    total_numbers = matrix.length * matrix[0].length
    x = 0
    y = 0
    min_x = 0
    min_y = 1
    max_x = matrix[0].length - 1
    max_y = matrix.length - 1

    loop do
      # eat the number where we are
      result << matrix[y][x]

      # check if we're done
      return result if result.length == total_numbers

      # if we're at a wall, change heading and move wall
      if heading == :right && x == max_x
        heading = :down
        max_x -= 1
      elsif heading == :down && y == max_y
        heading = :left
        max_y -= 1
      elsif heading == :left && x == min_x
        heading = :up
        min_x += 1
      elsif heading == :up && y == min_y
        heading = :right
        min_y += 1
      end

      # move
      case heading
      when :right
        x += 1
      when :down
        y += 1
      when :left
        x -= 1
      when :up
        y -= 1
      end
    end
  end
end

test_cases = [
  {
    params: [[[1]]],
    result: [1],
  },
  {
    params: [[[1], [2]]],
    result: [1, 2],
  },
  {
    params: [[[1, 2]]],
    result: [1, 2],
  },
  {
    params: [[[1, 2], [3, 4]]],
    result: [1, 2, 4, 3],
  },
  {
    params: [[[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
    result: [1, 2, 3, 6, 9, 8, 7, 4, 5],
  },
  {
    params: [[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]],
    result: [1, 2, 3, 4, 8, 12, 11, 10, 9, 5, 6, 7],
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
