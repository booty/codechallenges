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
  # This is performant, and passes
  def self.rubyish(lists)
    everything = []

    lists.each do |list|
      curr = list
      loop do
        break unless curr

        everything << curr
        putsif "adding #{curr.val}"
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

test_cases = [
  {
    params: [[
      [1, 4, 5],
      [1, 3, 4],
      [2, 6],
    ].map { |x| ListNode.from_array(x) }],
    result: [1, 1, 2, 3, 4, 4, 5, 6],
  },
  {
    params: [[]],
    result: [],
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  custom_comparison: ->(actual, expected) { actual.to_array == expected },
)
