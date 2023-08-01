# frozen_string_literal: true

require_relative "common/testrunner"

DEBUG = true

class ListNode
  attr_accessor :val, :next

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

  def initialize(val = 0, _next = nil)
    @val = val
    @next = _next
  end

  def <=>(other)
    val <=> other.val
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

  def to_s
    to_array.join("->")
  end
end

class Solutions
  # Mimics a C-like approach with pointers and no fancy
  # Ruby facilities.
  def self.oldskool(lists)
    # 1. look at the head node of each list
    # 2. find the lowest one
    # 3. link the previous node on our new list to that one

    # we have an array of pointers, one for each list
    pointers = Array.new(lists.length)
    head = nil
    tail = nil

    loop do
      low_value = nil
      low_index = nil
      lists.each_index do |index|
        # if it's our first time through the loop, set initial pointer for each list
        pointers[index] = lists[index] unless head

        # Do we have a node remaining for this list?
        next unless (current_node = pointers[index])

        # This is the first node in this iteration so obviously it's the
        # lowest value (for now)
        if index.zero?
          low_value = current_node.val
          low_index = index
          next
        end

        # is this the lowest value we've found yet in this iteration?
        if low_value.nil? || current_node.val < low_value
          low_value = current_node.val
          low_index = index
        end
      end

      # No nodes left. We're done!
      return head if low_value.nil?

      lowest_node = pointers[low_index]

      # Advance the pointer of the list we picked
      pointers[low_index] = lowest_node.next

      if head
        tail.next = lowest_node
      else
        head = lowest_node
      end
      tail = lowest_node
      tail.next = nil
    end
  end

  # This is performant, and passes @ leetcode w/ high marks
  # This is either a great solution (because we're making good use of
  # ruby) or kind of a cheaty one
  def self.rubyish(lists)
    everything = []

    lists.each do |list|
      curr = list
      loop do
        break unless curr

        everything << curr
        break unless curr.next

        curr = curr.next
      end
    end

    head = nil
    prev = nil
    everything.sort.each do |curr|
      if prev
        prev.next = curr
      else
        head = curr
      end
      prev = curr
    end
    head
  end
end

# TODO: find a way to recreate (lambda?) the test params between runs

test_cases = [
  {
    params: -> {
              [[
                [1, 4, 5],
                [2, 3, 4],
                [2, 6],
              ].map { |x| ListNode.from_array(x) }]
            },
    result: [1, 2, 2, 3, 4, 4, 5, 6],
  },
  # {
  #   params: [[]],
  #   result: nil,
  # },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  custom_comparison: ->(actual, expected) { actual&.to_array == expected },
)
