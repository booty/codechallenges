# frozen_string_literal: true

require_relative "testrunner"

# 21. Merge Two Sorted Lists (Easy)
#
# You are given the heads of two sorted linked lists list1 and list2.
#
# Merge the two lists into one sorted list. The list should be made by splicing
# together the nodes of the first two lists.
#
# Return the head of the merged linked list.
#
# Example 1:
#
# Input: list1 = [1,2,4], list2 = [1,3,4]
# Output: [1,1,2,3,4,4]
#
# Example 2:
#
# Input: list1 = [], list2 = []
# Output: []
#
# Example 3:
#
# Input: list1 = [], list2 = [0]
# Output: [0]
#
# Constraints:
#
#     The number of nodes in both lists is in the range [0, 50].
#     -100 <= Node.val <= 100
#     Both list1 and list2 are sorted in non-decreasing order.

class ListNode
  attr_accessor :val, :next

  def initialize(val = 0, _next = nil)
    @val = val
    @next = _next
  end

  def self.from_array(ary)
    head = nil
    previous = nil
    ary.reverse_each do |i|
      previous = head
      head = new(i, previous)
    end
    head
  end

  def to_a
    result = []
    pointer = self
    while pointer
      result << pointer.val
      pointer = pointer.next
    end
    result
  end
end

class Solutions
  def self.first(list1, list2)
    p1 = list1
    p2 = list2
    merged_head = nil
    merged_tail = nil

    while p1 || p2
      result = nil
      if p1.nil? || (p2 && p2.val < p1.val)
        result = p2.val
        p2 = p2.next
      else
        result = p1.val
        p1 = p1.next
      end

      new_node = ListNode.new(result)

      if merged_head
        merged_tail.next = new_node
      else
        merged_head = new_node
      end
      merged_tail = new_node
    end

    merged_head
  end
end

test_cases = [
  {
    params: [
      ListNode.from_array([1, 2, 4]),
      ListNode.from_array([1, 3, 4]),
    ],
    result: [1, 1, 2, 3, 4, 4],
  },
  {
    params: [
      ListNode.from_array([]),
      ListNode.from_array([]),
    ],
    result: [],
  },
  {
    params: [
      ListNode.from_array([]),
      ListNode.from_array([0]),
    ],
    result: [0],
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  custom_comparison: ->(actual_result, expected_result) {
    actual_result.to_a == expected_result
  },
)
