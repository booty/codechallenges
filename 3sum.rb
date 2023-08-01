# frozen_string_literal: true

require_relative "common/testrunner"

DEBUG = true

# Given an integer array nums, return all the triplets [nums[i], nums[j],
# nums[k]] such that i != j, i != k, and j != k, and nums[i] + nums[j] +
# nums[k] == 0.
#
# Notice that the solution set must not contain duplicate triplets.
#
# Example 1:
#
#    Input: nums = [-1,0,1,2,-1,-4]
#    Output: [[-1,-1,2],[-1,0,1]]
#    Explanation:
#    nums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0.
#    nums[1] + nums[2] + nums[4] = 0 + 1 + (-1) = 0.
#    nums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0.
#    The distinct triplets are [-1,0,1] and [-1,-1,2].
#    Notice that the order of the output and the order of the
#    triplets does not matter.
#
# Example 2:
#
#    Input: nums = [0,1,1]
#    Output: []
#    Explanation: The only possible triplet does not sum up to 0.
#
# Example 3:
#
#    Input: nums = [0,0,0]
#    Output: [[0,0,0]]
#    Explanation: The only possible triplet sums up to 0.
#
# Constraints:
#
#     3 <= nums.length <= 3000
#     -10^5 <= nums[i] <= 10^5

class Solutions
  def self.map(nums)
    map = {}
    results = Set.new
    sorted = nums.sort
    sorted.each_with_index do |val, index|
      map[val] = index
    end

    putsif "--- start #{sorted} ---"

    putsif "map:#{map}"
    sorted.each_with_index do |val_i, index_i|
      sorted.each_with_index do |val_j, index_j|
        next if index_i == index_j

        putsif "  val_i:#{val_i}, index_i:#{index_i}, val_j:#{val_j}, index_j:#{index_j}"

        # find the index of something that would make i + j + k == 0
        putsif "    do we have an element with value #{0-(val_i + val_j)}?"
        index_k = map[0 - (val_i + val_j)]

        next unless index_k
        next if index_k == index_i
        next if index_k == index_j

        putsif "      winner:#{sorted[index_k]} @ #{index_k}"
        results << [val_i, val_j, sorted[index_k]].sort
      end
    end

    results.to_a
  end

  # too slow with large arrays, time limit exceeded
  def self.countup(nums)
    sorted = nums.sort
    putsif "sorted:#{sorted}"
    results = []
    a = 0
    while a < sorted.length - 2
      a_val = sorted[a]
      break if a_val.positive?

      b = a + 1
      while b < sorted.length - 1
        b_val = sorted[b]
        ab_sum = a_val + b_val
        break if ab_sum.positive?

        c = b + 1
        while c < sorted.length
          c_val = sorted[c]
          foo = [a_val, b_val, c_val]
          putsif "  a:#{a}(#{a_val}), b:#{b}(#{b_val}), c:#{c}(#{c_val})\t#{foo}"
          sum = foo.sum

          results << foo if sum.zero?

          break if sum.positive?

          c += 1
        end
        b += 1
      end
      a += 1
    end
    results.uniq
  end
end

test_cases = [
  # {
  #   params: [[-1, 0, 1, 2, -1, -4, -2, -3, 3, 0, 4]],
  #   result: [[-4, 0, 4], [-4, 1, 3], [-3, -1, 4], [-3, 0, 3], [-3, 1, 2], [-2, -1, 3], [-2, 0, 2], [-1, -1, 2],
  #            [-1, 0, 1]],
  # },
  {
    params: [[-2, -1, 0, 0, 100, 999]],
    result: [],
  },
  {
    params: [[-666, 1, 1, 1, 1, 1]],
    result: [],
  },
  {
    params: [[-1, 0, 1, 2, -1, -4]],
    result: [[-1, -1, 2], [-1, 0, 1]],
  },
  {
    params: [[0, 1, 1]],
    result: [],
  },
  {
    params: [[0, 0, 0]],
    result: [[0, 0, 0]],
  },
  {
    params: [[1, 1, -2]],
    result: [[-2, 1, 1]],
  },
  {
    params: [[-2, 0, 1, 1, 2]],
    result: [[-2, 0, 2], [-2, 1, 1]],
  },
  {
    label: "biggun 1",
    params: [[0, 8, 2, -9, -14, 5, 2, -5, -5, -9, -1, 3, 1, -8, 0, -3, -12, 2,
              11, 9, 13, -14, 2, -15, 4, 10, 9, 7, 14, -8, -2, -1, -15, -15, -2,
              8, -3, 7, -12, 8, 6, 2, -12, -8, 1, -4, -3, 5, 13, -7, -1, 11,
              -13, 8, 4, 6, 3, -2, -2, 3, -2, 3, 9, -10, -4, -8, 14, 8, 7, 9,
              1, -2, -3, 5, 5, 5, 8, 9, -5, 6, -12, 1, -5, 12, -6, 14, 3, 5,
              -11, 8, -7, 2, -12, 9, 8, -1, 9, -1, -7, 1, -7, 1, 14, -3, 13,
              -4, -12, 6, -9, -10, -10, -14, 7, 0, 13, 8, -9, 1, -2, -5, -14]],
    result: [[-15, 1, 14], [-15, 2, 13], [-15, 3, 12], [-15, 4, 11],
             [-15, 5, 10], [-15, 6, 9], [-15, 7, 8], [-14, 0, 14], [-14, 1, 13],
             [-14, 2, 12], [-14, 3, 11], [-14, 4, 10], [-14, 5, 9], [-14, 6, 8],
             [-14, 7, 7], [-13, -1, 14], [-13, 0, 13], [-13, 1, 12],
             [-13, 2, 11], [-13, 3, 10], [-13, 4, 9], [-13, 5, 8], [-13, 6, 7],
             [-12, -2, 14], [-12, -1, 13], [-12, 0, 12], [-12, 1, 11],
             [-12, 2, 10], [-12, 3, 9], [-12, 4, 8], [-12, 5, 7], [-12, 6, 6],
             [-11, -3, 14], [-11, -2, 13], [-11, -1, 12], [-11, 0, 11],
             [-11, 1, 10], [-11, 2, 9], [-11, 3, 8], [-11, 4, 7], [-11, 5, 6],
             [-10, -4, 14], [-10, -3, 13], [-10, -2, 12], [-10, -1, 11],
             [-10, 0, 10], [-10, 1, 9], [-10, 2, 8], [-10, 3, 7], [-10, 4, 6],
             [-10, 5, 5], [-9, -5, 14], [-9, -4, 13], [-9, -3, 12],
             [-9, -2, 11], [-9, -1, 10], [-9, 0, 9], [-9, 1, 8], [-9, 2, 7],
             [-9, 3, 6], [-9, 4, 5], [-8, -6, 14], [-8, -5, 13], [-8, -4, 12],
             [-8, -3, 11], [-8, -2, 10], [-8, -1, 9], [-8, 0, 8], [-8, 1, 7],
             [-8, 2, 6], [-8, 3, 5], [-8, 4, 4], [-7, -7, 14], [-7, -6, 13],
             [-7, -5, 12], [-7, -4, 11], [-7, -3, 10], [-7, -2, 9],
             [-7, -1, 8], [-7, 0, 7], [-7, 1, 6], [-7, 2, 5], [-7, 3, 4],
             [-6, -5, 11], [-6, -4, 10], [-6, -3, 9], [-6, -2, 8], [-6, -1, 7],
             [-6, 0, 6], [-6, 1, 5], [-6, 2, 4], [-6, 3, 3], [-5, -5, 10],
             [-5, -4, 9], [-5, -3, 8], [-5, -2, 7], [-5, -1, 6], [-5, 0, 5],
             [-5, 1, 4], [-5, 2, 3], [-4, -4, 8], [-4, -3, 7], [-4, -2, 6],
             [-4, -1, 5], [-4, 0, 4], [-4, 1, 3], [-4, 2, 2], [-3, -3, 6],
             [-3, -2, 5], [-3, -1, 4], [-3, 0, 3], [-3, 1, 2], [-2, -2, 4],
             [-2, -1, 3], [-2, 0, 2], [-2, 1, 1], [-1, -1, 2], [-1, 0, 1],
             [0, 0, 0]],
  },

]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  custom_comparison: ->(a, b) { a.to_set == b.to_set },
)
