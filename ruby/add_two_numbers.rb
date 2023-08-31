# frozen_string_literal: true

require "pry-byebug"
require "benchmark/ips"

# https://leetcode.com/problems/add-two-numbers/
#
# You are given two non-empty linked lists representing two
# non-negative integers. The digits are stored in reverse
# order, and each of their nodes contains a single digit.
# Add the two numbers and return the sum as a linked list.
#
# Example 1:
#   Input: l1 = [2,4,3], l2 = [5,6,4]
#   Output: [7,0,8]
#   Explanation: 342 + 465 = 807.
#
# Example 2:
#   Input: l1 = [0], l2 = [0]
#   Output: [0]
#
# Example 3:
#   Input: l1 = [9,9,9,9,9,9,9], l2 = [9,9,9,9]
#   Output: [8,9,9,9,0,0,0,1]
#
# You may assume the two numbers do not contain any leading zero, except the number 0 itself.

BM_WARMUP_SECONDS = 0.5
BM_TIME_SECONDS = 2
DEBUG = false

class ListNode
  attr_accessor :val, :next

  def initialize(val = 0, _next = nil)
    @val = val
    @next = _next
  end

  def self.from_array(s)
    current_node = nil

    s.reverse_each do |i|
      new_node = ListNode.new(i, current_node)

      current_node = new_node
    end

    current_node
  end
end

class Solutions
  def self.chars(l1, l2)
    pos = 0
    sum = 0
    p1 = l1
    p2 = l2

    loop do
      multiplier = 10**pos

      n1 = p1 ? (p1.val * multiplier) : 0
      n2 = p2 ? (p2.val * multiplier) : 0

      sum += (n1 + n2)

      pos += 1

      p1 = p1.next if p1
      p2 = p2.next if p2
      break if p1.nil? && p2.nil?
    end

    sum.to_s.reverse.chars.map(&:to_i)
  end
end

test_cases = [
  { input: [[1, 2, 3], [1, 2, 3]], result: [2, 4, 6] },
  { input: [[2, 4, 9], [5, 6, 4, 9]], result: [7, 0, 4, 0, 1] },
  { input: [[2, 4, 3], [5, 6, 4]], result: [7, 0, 8] },
  { input: [[9, 9, 9, 9, 9, 9, 9], [9, 9, 9, 9]], result: [8, 9, 9, 9, 0, 0, 0, 1] },
  { input: [[0], [0]], result: [0] },
]

def putsif(str)
  puts str if DEBUG
end

class String
  def ellipsize(limit)
    return self if length <= limit

    "#{self[0..limit - 2]}…"
  end
end

def benchmark_label(method_name, test_case)
  "#{method_name}(#{test_case.except(:result).values.join(',').ellipsize(15)})"
end

Benchmark.ips do |bm|
  bm.config(time: BM_TIME_SECONDS, warmup: BM_WARMUP_SECONDS)
  methods = (Solutions.methods - Class.methods)
  methods.each do |meth|
    puts meth
    test_cases.each_with_index do |tcase, _tindex|
      print "  case #{tcase[:input]}"

      work = lambda do
        Solutions.send(
          meth,
          ListNode.from_array(tcase[:input][0]),
          ListNode.from_array(tcase[:input][1]),
        )
      end

      actual_result = work.call

      if actual_result == tcase[:result]
        puts " ✅ pass (#{actual_result})"
      else
        puts " ❌ fail!"
        puts "    actual: #{actual_result}"
        puts "    expected: #{tcase[:result]}"
      end

      label = benchmark_label(meth, tcase)
      bm.report(label) { work.call } unless DEBUG
    end
  end
end
