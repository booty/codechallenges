# frozen_string_literal: true

require_relative "common/testrunner"
require_relative "common/listnode"

# 24. Swap Nodes in Pairs (Medium)
#
# https://leetcode.com/problems/swap-nodes-in-pairs/
#
# Given a linked list, swap every two adjacent nodes and return its head. # You must
# solve the problem without modifying the values in the list's nodes (i.e., # only
# nodes themselves may be changed.)
#
# Example 1:
#
# Input: head = [1,2,3,4] Output: [2,1,4,3]
#
# Example 2:
#
# Input: head = [] Output: []
#
# Example 3:
#
# Input: head = [1] Output: [1]
#
# Constraints:
#
#     The number of nodes in the list is in the range [0, 100].
#     0 <= Node.val <= 100

class Solutions
  def self.letsgo(head)
    return head unless head # empty list
    return head unless head.next # single-element list
  end
end

test_cases = [
  {
    params: [ListNode.from_array([1, 2, 3, 4])],
    result: [2, 1, 4, 3],
  },
  {
    params: [ListNode.from_array],
    result: [],
  },
  {
    params: [ListNode.from_array([1])],
    result: [1],
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  custom_comparison: ->(actual_result, expected_result) {
    (actual_result&.to_array || []) == expected_result
  },
)
