# frozen_string_literal: true

require_relative "testrunner"

# https://leetcode.com/problems/find-the-index-of-the-first-occurrence-in-a-string/
#
# Given two strings needle and haystack, return the index of
# the first occurrence of needle in haystack, or -1 if needle
# is not part of haystack.
#
# Example 1:
#
#   Input: haystack = "sadbutsad", needle = "sad"
#   Output: 0
#   Explanation: "sad" occurs at index 0 and 6.
#   The first occurrence is at index 0, so we return 0.
#
# Example 2:
#
#   Input: haystack = "leetcode", needle = "leeto"
#   Output: -1
#   Explanation: "leeto" did not occur in "leetcode", so we return -1.

class Solutions
  def self.honest(haystack, needle)
    haystack_pos = 0
    needle_pos = 0
    match_start_pos = nil

    loop do
      haystack_char = haystack[haystack_pos]
      needle_char = needle[needle_pos]

      # putsif "haystack_pos:#{haystack_pos}(#{haystack_char}) " \
      #        "needle_pos:#{needle_pos}(#{needle_char}) " \
      #        "match_start_pos:#{match_start_pos} "

      return match_start_pos if needle_char.nil?
      return -1 unless haystack_char

      if haystack_char != needle_char
        needle_pos = 0
        needle_char = needle[0]
        if match_start_pos
          haystack_pos = match_start_pos + 1
          haystack_char = haystack[haystack_pos]
          match_start_pos = nil
        end
      end

      if haystack_char == needle_char
        # putsif "  match"
        if needle_pos.zero?
          # putsif "  match start"
          match_start_pos = haystack_pos
        else
          # putsif "  match continued"
        end
        needle_pos += 1
      end

      haystack_pos += 1
    end
  end

  def self.cheat(haystack, needle)
    haystack.index(needle) || -1
  end
end

test_cases = [
  {
    params: ["sadbutsad", "sad"],
    result: 0,
  },
  {
    params: ["leetcode", "leeto"],
    result: -1,
  },
  {
    params: ["johjohnjo", "john"],
    result: 3,
  },
  {
    params: ["a", "a"],
    result: 0,
  },
  {
    params: ["mississippi", "issip"],
    result: 4,
  },
  {
    params: [
      "asdlajknfvdkslfjnvsdfkljvnsdfklhjvlkfjnalkjvnlfhaslkfjvbnsdlkfjvbsdklfjvbnsdklfjvndlfjkvnsdkljfnvsldkjfnvlslkdfjvnsdklfjvnsdfkljvnyep", "yep"
    ],
    result: 130,
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
)
