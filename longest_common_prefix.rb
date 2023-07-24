# frozen_string_literal: true

require_relative "testrunner"

# https://leetcode.com/problems/longest-common-prefix/
#
# Write a function to find the longest common prefix string amongst an array of strings.
#
# If there is no common prefix, return an empty string "".
#
# Example 1:
#
# Input: strs = ["flower","flow","flight"]
# Output: "fl"
#
# Example 2:
#
# Input: strs = ["dog","racecar","car"]
# Output: ""
# Explanation: There is no common prefix among the input strings.
#
# Constraints:
#
#     1 <= strs.length <= 200
#     0 <= strs[i].length <= 200
#     strs[i] consists of only lowercase English letters.

class Solutions
  # optimized, about 30% faster. pretty close to max perf?
  def self.parallel2(strs)
    num_strs = strs.length
    result_len = 0

    min_length = strs.map(&:length).min

    0.upto(min_length - 1) do |i|
      all_match = true
      comp_char = strs[0][i]
      1.upto(num_strs - 1) do |str_num|
        c = strs[str_num][i]
        all_match = false unless strs[str_num][i] == comp_char
      end

      break unless all_match

      result_len += 1
    end

    return "" if result_len.zero?

    strs[0][0..result_len - 1]
  end

  # passes, performs
  def self.parallel(strs)
    num_strs = strs.length
    result_len = 0

    min_length = strs.map(&:length).min

    0.upto(min_length - 1) do |i|
      all_match = true
      strs.each do |str|
        c = str[i]

        if c.nil?
          all_match = false
        else
          all_match = false unless str[i] == strs[0][i]
        end
      end

      break unless all_match

      result_len += 1
    end

    return "" if result_len.zero?

    strs[0][0..result_len - 1]
  end
end

VALID_CHARS = ("a".."z").to_a

LONG_RANDOM_STRING_1 = VALID_CHARS.sample(10_000_000).join

test_cases = [
  {
    params: [["flower", "flow", "flight"]],
    result: "fl",
  },
  {
    params: [["dog", "racecar"]],
    result: "",
  },
  {
    params: [Array.new(3) { LONG_RANDOM_STRING_1 }],
    result: LONG_RANDOM_STRING_1,
    label: "3 long random",
  },
  {
    params: [Array.new(300) { LONG_RANDOM_STRING_1 }],
    result: LONG_RANDOM_STRING_1,
    label: "300 long random",
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
  # label: "my friendly label",
)
