# frozen_string_literal: true

require_relative "common/testrunner"

# 39. Combination Sum Medium
#
# https://leetcode.com/problems/combination-sum/
#
# Given an array of distinct integers candidates and a target integer target,
# return a list of all unique combinations of candidates where the chosen numbers
# sum to target. You may return the combinations in any order.
#
# The same number may be chosen from candidates an unlimited number of times. Two
# combinations are unique if the frequency of at least one of the chosen numbers
# is different.
#
# The test cases are generated such that the number of unique combinations that
# sum up to target is less than 150 combinations for the given input.
#
# Example 1:
#
# Input: candidates = [2,3,6,7], target = 7 Output: [[2,2,3],[7]] Explanation: 2
# and 3 are candidates, and 2 + 2 + 3 = 7. Note that 2 can be used multiple times.
# 7 is a candidate, and 7 = 7. These are the only two combinations.
#
# Example 2:
#
# Input: candidates = [2,3,5], target = 8 Output: [[2,2,2,2],[2,3,3],[3,5]]
#
# Example 3:
#
# Input: candidates = [2], target = 1 Output: []
#
# Constraints:
#
#     1 <= candidates.length <= 30
#     2 <= candidates[i] <= 40
#     All elements of candidates are distinct.
#     1 <= target <= 40

class TreeNode
  attr_accessor :parent, :solutions

  def root
    pointer = self

    while pointer.parent
      pointer = pointer.parent
    end

    pointer
  end

  # passes, kind of slow
  def initialize(candidates:, target:, parent: nil, ary: [], depth: 0)
    @parent = parent

    # putsif "#{' ' * 2 * depth}[initialize] candidates:#{candidates} " \
    #        "ary:#{ary}"

    my_sum = ary.sum
    candidates.each do |candidate|
      new_ary_sum = my_sum + candidate

      next if new_ary_sum > target

      new_ary = ary + [candidate]

      if new_ary_sum == target
        myroot = root
        new_ary_sorted = new_ary.sort
        myroot.solutions ||= Set.new
        myroot.solutions.add(new_ary_sorted)
        next
      end

      TreeNode.new(
        candidates:,
        parent: self,
        ary: new_ary,
        target:,
        depth: depth + 1,
      )
    end
  end
end

class Solutions
  def self.omg(candidates, target)
    TreeNode.new(candidates:, target:).solutions || []
  end
end

test_cases = [
  {
    params: [[2, 3, 5], 8],
    result: [[2, 2, 2, 2], [2, 3, 3], [3, 5]],
  },
  {
    params: [[2], 1],
    result: [],
  },
  {
    params: [[2, 3, 6, 7], 7],
    result: [[2, 2, 3], [7]],
  },
  {
    params: [[8, 7, 4, 3], 11],
    result: [[8, 3], [7, 4], [4, 4, 3]],
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  custom_comparison: ->(a, b) {
    a.sort == b.map(&:sort).sort
  },
  # label: "my friendly label",
)
