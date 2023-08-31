# frozen_string_literal: true

require_relative "common/testrunner"

DEBUG = true

# https://leetcode.com/problems/remove-nth-node-from-end-of-list/
#
# Given the head of a linked list, remove the nth node
# from the end of the list and return its head.
#
# Example 1:
#
# Input: head = [1,2,3,4,5], n = 2
# Output: [1,2,3,5]
#
# Example 2:
#
# Input: head = [1], n = 1
# Output: []
#
# Example 3:
#
# Input: head = [1,2], n = 1
# Output: [1]

class ListNode
  attr_accessor :val, :next

  def initialize(val = 0, _next = nil)
    @val = val
    @next = _next
  end

  def self.from_array(ary)
    head = nil
    prev = nil
    ary.each do |x|
      curr = new(x)
      prev.next = curr if prev
      prev = curr
      head ||= curr
    end
    head
  end

  def length
    length = 1

    curr = self

    while curr.next
      length += 1
      curr = curr.next
    end

    length
  end

  def to_array
    result = [val]
    curr = self
    while curr.next
      curr = curr.next
      result << curr.val
    end

    result
  end
end

class Solutions
  def self.remove_nth_from_end(head, n)
    len = head.length
    return nil if len == 1

    index_to_delete = len - n

    return head.next.to_array if index_to_delete == 0

    curr = head

    1.upto(index_to_delete) do |index|
      if index == index_to_delete
        curr.next = curr.next.next
      else
        curr = curr.next
      end
    end

    head.to_array
  end
end

test_cases = [
  {
    params: [ListNode.from_array([1, 2, 3, 4, 5]), 2],
    result: [1, 2, 3, 5],
  },
  {
    params: [ListNode.from_array([1]), 1],
    result: nil,
  },
  {
    params: [ListNode.from_array([1, 2]), 1],
    result: [1],
  },
  {
    params: [ListNode.from_array([1, 2]), 2],
    result: [2],
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
)
