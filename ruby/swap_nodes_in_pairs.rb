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

    new_head = nil
    lagger = nil
    middle = head
    leader = head.next

    # suppose A->B->C->D
    # initially: middle=A, leader=B
    while leader
      # lagger.next would now be A (if it existed)
      lagger.next = leader if lagger

      # A.next is now C
      middle.next = leader.next

      # B.next is now A
      leader.next = middle

      # list is now B->A->C->D
      # lagger is now B
      lagger = middle

      # middle is now
      middle = lagger.next

      # middle is now B
      new_head ||= leader
      leader = lagger.next&.next

      # putsif "lagger:#{lagger} " \
      #        "middle:#{middle} " \
      #        "leader:#{leader} " \
      #        "new_head:#{new_head}"
    end

    new_head || head
  end
end

def input_array(num:)
  (1..num).to_a
end

def result_array(num:)
  input_array = input_array(num:)
  (0..input_array.length - 1).step(2) do |i|
    t = input_array[i + 1]
    break unless t

    input_array[i + 1] = input_array[i]
    input_array[i] = t
  end
  input_array
end

test_cases = [
  {
    params: [ListNode.from_array([1, 2, 3, 4])],
    result: [2, 1, 4, 3],
  },
  {
    params: [ListNode.from_array([1, 2, 3, 4, 5])],
    result: [2, 1, 4, 3, 5],
  },
  {
    params: [ListNode.from_array],
    result: [],
  },
  {
    params: [ListNode.from_array([1])],
    result: [1],
  },
  {
    params: [ListNode.from_array(input_array(num: 10_000))],
    result: result_array(num: 10_000),
    label: "10K elements",
  },
  {
    params: [ListNode.from_array(input_array(num: 100_000))],
    result: result_array(num: 100_000),
    label: "100K elements",
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  custom_comparison: ->(actual_result, expected_result) {
    (actual_result&.to_array || []) == expected_result
  },
)
