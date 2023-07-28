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

  def self.array_to_list(ary)
    head = nil
    previous = nil
    ary.reverse_each do |i|
      previous = head
      head = new(i, previous)
    end
    head
  end
end

class Solutions
  def self.first(list1, list2)
    list1_pointer = 0
    list2_pointer = 0
    result = []

    while list1_pointer < list1.length || list2_pointer < list2.length
      list1_val = list1[list1_pointer]
      list2_val = list2[list2_pointer]

      # putsif "list1_pointer:#{list1_pointer} list1_val:#{list1_val} list2_pointer:#{list2_pointer} list2_val:#{list2_val}"
      result << if list1_val.nil?
                  list2_pointer += 1
                  # puts "  chose from list2 because list1 empty"
                  list2_val
                elsif list2_val.nil?
                  list1_pointer += 1
                  # puts "  chose from list1 because list2 empty"
                  list1_val
                elsif list2_val < list1_val
                  list2_pointer += 1
                  # puts "  chose from list2 because #{list2_val} < #{list1_val}"
                  list2_val
                else
                  list1_pointer += 1
                  # puts "  chose from list2 because #{list1_val} <= #{list2_val}"
                  list1_val
                end
      # putsif "  list1_val:#{list1_val} list2_val:#{list2_val} result:#{result}"
    end
    result
  end
end

test_cases = [
  {
    params: [[1, 2, 4], [1, 3, 4]],
    result: [1, 1, 2, 3, 4, 4],
  },
  {
    params: [[], []],
    result: [],
  },
  {
    params: [[], [0]],
    result: [0],
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
