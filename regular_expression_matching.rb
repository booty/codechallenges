# frozen_string_literal: true

require "pry-byebug"
require "benchmark/ips"

# https://leetcode.com/problems/regular-expression-matching/
# Given an input string s and a pattern p, implement regular expression matching with support for '.' and '*' where:

#     '.' Matches any single character.
#     '*' Matches zero or more of the preceding element.

# The matching should cover the entire input string (not partial).
#
# Example 1:
#
#   Input: s = "aa", p = "a"
#   Output: false
#   Explanation: "a" does not match the entire string "aa".
#
# Example 2:
#
#   Input: s = "aa", p = "a*"
#   Output: true
#   Explanation: '*' means zero or more of the preceding element, 'a'. Therefore, by repeating 'a' once, it becomes "aa".
#
# Example 3:
#
#   Input: s = "ab", p = ".*"
#   Output: true
#   Explanation: ".*" means "zero or more (*) of any character (.)".

BM_WARMUP_SECONDS = 0.5
BM_TIME_SECONDS = 2
DEBUG = true

def classify(c)
  case c
  when /[a-z0-9.]/i
    :literal
  when nil
    :eos
  when "*"
    :zero_or_more
  else
    raise "Inappropriate char: #{c}"
  end
end

class Solutions
  def self.cheat(str, pat)
    !!(str =~ /\A#{pat}\Z/)
  end

  def self.chunky(str, pat)
    chunks = str.split("*")

    str_pos = 0
    pat_pos = 0

    while pat_pos < pat.length
      pat_current_c = pat[pat_pos]
      pat_next_c = pat[pat_pos + 1]
      pat_current_type = classify(pat_current_c)
      pat_next_type = classify(pat_next_c)

      debug_string = "pat_pos:#{pat_pos} " \
        "pat_current_c:#{pat_current_c}(#{pat_current_type}) " \
        "pat_next_c:#{pat_next_c}(#{pat_next_type}) "

      if pat_current_type == :zero_or_more
        raise "#{debug_string} unexpected #{pat_current_c} at bos"
      end

      case [pat_current_type, pat_next_type]
      when [:literal, :literal], [:literal, :eos]
        putsif "#{debug_string} should match literal #{pat_current_c}"
      when [:literal, :zero_or_more]
        putsif "#{debug_string} should match one or more #{pat_current_c}"
        pat_pos += 1
      when [:one_or_more, :one_or_more]
        raise "#{debug_string} unexpected double operator"
      else
        raise "#{debug_string} i'm so confused"
      end

      pat_pos += 1
    end
  end

  # def self.naive(str, pat)
  #   def type(chr)
  #     return :dot if chr == "."
  #     return :star if chr == "*"
  #     return :letter if ("a".."z").include?(chr)
  #     return :eos if chr.nil?

  #     raise ArgumentError, "unrecognized pattern character: #{chr}"
  #   end

  #   # special easy case
  #   unless str.include?(".") || str.include?("*")
  #     return str == pat
  #   end

  #   pat_pos = 0
  #   0.upto(str.length - 1) do |str_pos|
  #     str_c = str[str_pos]
  #     pat_c = pat[pat_pos]
  #     pat_c_next = pat[pat_pos]

  #   end
  # end
end

test_cases = [
  { input: "aa", pattern: "a", result: false },
  { input: "john", pattern: "john", result: true },
  { input: "aa", pattern: "a*", result: true },
  { input: "ab", pattern: ".*", result: true },
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

      work = lambda { Solutions.send(meth, tcase[:input], tcase[:pattern]) }
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
