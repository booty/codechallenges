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
#   Explanation: '*' means zero or more of the preceding element,
#    'a'. Therefore, by repeating 'a' once, it becomes "aa".
#
# Example 3:
#
#   Input: s = "ab", p = ".*"
#   Output: true
#   Explanation: ".*" means "zero or more (*) of any character (.)".

BM_WARMUP_SECONDS = 0.5
BM_TIME_SECONDS = 2
DEBUG = false

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

# returns the length of the match (can be zero)
def match_zero_or_more(str, start_pos, match_char, stop_char)
  pos = start_pos
  stop_char_equals_first_char = (str[pos] == stop_char)
  reps = 0

  while pos < str.length
    reps += 1
    raise "too many reps" if reps > 25

    c = str[pos]

    putsif("   match_zero_or_more | pos:#{pos} c:#{c} match_char:#{match_char} stop_char:#{stop_char}")

    unless c # end of string
      putsif("     end of string")
      break
    end
    if (c == stop_char) && !stop_char_equals_first_char
      putsif("     hit the stop char (#{c} == #{stop_char})")
      break
    end
    unless (c == match_char) || (match_char == ".")
      putsif("     no match (#{c} != #{match_char})")
      break
    end
    pos += 1
  end

  result = pos - start_pos
  if result.positive? && stop_char_equals_first_char
    putsif("    back it up by one since stop_char_equals_first_char")
    result -= 1
  end

  putsif("   match_zero_or_more returning #{result}")
  result
end

def optimize_pattern(p)
  start = p[0..1]
  optimized = p.chars.uniq.join
  optimized == start && start[0] != "." && start[1] == "*" ? optimized : p
end

class Solutions
  def self.cheat(str, pat)
    !!(str =~ /\A#{pat}\Z/)
  end

  # Not my solution :-(
  def self.match?(s, p, initial = true)
    # special simple case
    unless p.include?("*") || p.include?(".")
      return s == p
    end

    p = optimize_pattern(p) if initial
    return s.empty? if p.empty?

    first = !s.empty? && [s[0], "."].include?(p[0])
    if p.length >= 2 && p[1] == "*"
      match?(s, p[2..], false) || (first && match?(s[1..], p, false))
    else
      first && match?(s[1..], p[1..], false)
    end
  end

  def self.mine(str, pat)
    # special simple case
    unless pat.include?("*") || pat.include?(".")
      return str == pat
    end

    putsif("....start....")
    str_pos = 0
    pat_pos = 0
    result = true

    while (pat_pos < pat.length) && result
      pat_current_c = pat[pat_pos]
      pat_next_c = pat[pat_pos + 1]
      pat_current_type = classify(pat_current_c)
      pat_next_type = classify(pat_next_c)
      str_current_c = str[str_pos]

      # debug_string = "pat_pos:#{pat_pos} " \
      #   "pat_current_c:#{pat_current_c}(#{pat_current_type}) " \
      #   "pat_next_c:#{pat_next_c}(#{pat_next_type}) "

      debug_string = "str_pos:#{str_pos}(#{str_current_c}) " \
                     "pat_pos:#{pat_pos}(#{pat_current_c}, #{pat_current_type}) " \
                     "pat_next:(#{pat_next_c}, #{pat_next_type})"

      if pat_current_type == :zero_or_more
        raise "#{debug_string} unexpected #{pat_current_c}"
      end

      if pat_next_c.nil? && (pat_current_c == ".")
        putsif "#{debug_string} special case: "
      end

      case [pat_current_type, pat_next_type]
      when [:literal, :literal], [:literal, :eos]
        putsif "#{debug_string} should match literal #{str_current_c}==#{pat_current_c}?"
        result = (pat_current_c == str_current_c) || (pat_current_c == ".")
        str_pos += 1
        pat_pos += 1
      when [:literal, :zero_or_more]
        putsif "#{debug_string} should match zero or more #{pat_current_c}"
        str_pos += match_zero_or_more(str, str_pos, pat_current_c, pat[pat_pos + 2])
        pat_pos += 2
      else
        raise "#{debug_string} i'm so confused"
      end

    end

    putsif("we're at the end str.length:#{str.length} str_pos:#{str_pos}")
    return false unless str_pos == str.length

    putsif("guess the result is... #{result}")
    result
  end
end

test_cases = [
  { input: "aaa", pattern: "a*a", result: true },
  { input: "john", pattern: "john", result: true },
  { input: "aa", pattern: "a", result: false },
  { input: "aa", pattern: "a*", result: true },
  { input: "ab", pattern: ".*", result: true },
  { input: "abc", pattern: ".*c", result: true },
  { input: "abc", pattern: ".*d", result: false },
  { input: "mississippi", pattern: "mis*is*ip*.", result: true },
  { input: "aaa", pattern: "ab*a*c*a", result: true },
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
      print "  case #{tcase[:input]} | #{tcase[:pattern]}"

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
