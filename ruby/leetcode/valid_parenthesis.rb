# frozen_string_literal: true

# https://leetcode.com/problems/valid-parentheses/
#
# Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.
#
# An input string is valid if:
#
#     Open brackets must be closed by the same type of brackets.
#     Open brackets must be closed in the correct order.
#     Every close bracket has a corresponding open bracket of
#     the same # type.
#
# Example 1:
# Input: s = "()"
# Output: true
#
# Example 2:
# Input: s = "()[]{}"
# Output: true
#
# Example 3:
# Input: s = "(]"
# Output: false

require "pry-byebug"
require "benchmark/ips"

BM_WARMUP_SECONDS = 0.5
BM_TIME_SECONDS = 2
DEBUG = false

class Solutions
  def self.naive(s)
    stack = []

    s.each_char do |c|
      case c
      when "(", "[", "{"
        stack << c
      when ")"
        return false unless stack.pop == "("
      when "]"
        return false unless stack.pop == "["
      when "}"
        return false unless stack.pop == "{"
      end
    end

    stack.empty?
  end
end

test_cases = [
  { input: "()", result: true },
  { input: "()[{}]", result: true },
  { input: "([)]", result: false },
  { input: "", result: true },
  { input: ")", result: false },
  { input: "[", result: false },
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

      work = lambda { Solutions.send(meth, tcase[:input]) }
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
