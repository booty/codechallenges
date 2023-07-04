# frozen_string_literal: true

require_relative "testrunner"

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
  # mimics a C-like approach with pointers and no fancy
  # Ruby facilities
  def self.oldskool(lists)
    # 1. look at the head node of each list
    # 2. find the lowest one
    # 3. link the previous node on our new list to that one

    # we have an array of pointers, one for each list
    pointers = Array.new(lists.length)
    head = nil
    tail = nil
    deleteme_iteration_count = -1

    loop do
      low_value = nil
      low_index = nil
      deleteme_iteration_count += 1
      # putsif "--[ iteration #{deleteme_iteration_count} head:#{head} ]--"

      # putsif pointers.map(&:to_s)

      lists.each_index do |index|
        # putsif "index:#{index}"

        # if it's our first time through the loop, set initial pointer for each list
        unless head
          pointers[index] = lists[index]
          # putsif "  First time through the loop; setting pointers[#{index}] to #{lists[index]}"
        end

        # Do we have a node remaining for this list?
        # binding.pry if deleteme_iteration_count == 2
        if (current_node = pointers[index])
          # putsif "  Current node: #{current_node}"
          # pointers[index] = current_node.next
        else
          # putsif "  No nodes left for this list; next"
          next
        end

        # This is the first node in this iteration so obviously it's the
        # lowest value (for now)
        if index.zero?
          # binding.pry if deleteme_iteration_count == 1
          low_value = current_node.val
          low_index = index
          # putsif "  Setting initial low value to #{low_value} (index #{index})"
          # binding.pry if deleteme_iteration_count == 1
          next
        end

        # is this the lowest value we've found yet in this iteration?
        # # putsif "Is #{current_node.val}<#{low_value}?"
        if low_value.nil? || current_node.val < low_value
          # putsif "  We have a new lowest value"
          low_value = current_node.val
          low_index = index
        end
      end

      # binding.pry if deleteme_iteration_count == 3
      if low_value.nil?
        # I guess there were no nodes left. We're done!
        # putsif "No nodes left!"
        return head
      end

      lowest_node = pointers[low_index]

      # Advance the pointer of the list we picked
      # binding.pry if deleteme_iteration_count == 3
      pointers[low_index] = lowest_node.next
      # putsif "Advancing pointer of list ##{low_index} which is now #{pointers[low_index]}"
      # binding.pry if deleteme_iteration_count == 3

      # putsif "lowest_node.val:#{lowest_node.val}"
      if head
        # putsif "Setting tail.next to #{lowest_node}"
        tail.next = lowest_node
      else
        # putsif "This was our first iteration, so we're setting head to #{lowest_node} (val:#{low_value} index:#{low_index})"
        head = lowest_node
      end
      tail = lowest_node
      tail.next = nil
      binding.pry if tail.next == tail # uh oh

      # putsif "head is now #{head}"
    end
  end


  # This is performant, and passes @ leetcode w/ high marks
  # This is either a great solution (because we're making good use of
  # ruby) or kind of a cheaty one
  # def self.rubyish(lists)
  #   everything = []

  #   lists.each do |list|
  #     curr = list
  #     loop do
  #       break unless curr

  #       everything << curr
  #       putsif "adding #{curr.val}"
  #       break unless curr.next

  #       curr = curr.next
  #     end
  #   end

  #   head = nil
  #   prev = nil
  #   everything.sort.each do |curr|
  #     if prev
  #       prev.next = curr
  #     else
  #       head = curr
  #     end
  #     prev = curr
  #   end
  #   head
  # end
end

# TODO: find a way to recreate (lambda?) the test params between runs

test_cases = [
  {
    params: [[
      [1, 4, 5],
      [2, 3, 4],
      [2, 6],
    ].map { |x| ListNode.from_array(x) }],
    result: [1, 2, 2, 3, 4, 4, 5, 6],
  },
  # {
  #   params: [[]],
  #   result: [],
  # },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  custom_comparison: ->(actual, expected) { actual.to_array == expected },
)
