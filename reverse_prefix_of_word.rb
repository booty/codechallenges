# frozen_string_literal: true

require_relative "common/testrunner"

# https://leetcode.com/problems/reverse-prefix-of-word/description/
#
# 2000. Reverse Prefix of Word
#
# Given a 0-indexed string word and a character ch, reverse the segment of word
# that starts at index 0 and ends at the index of the first occurrence of ch
# (inclusive). If the character ch does not exist in word, do nothing.
#
# For example, if word = "abcdefd" and ch = "d", then you should reverse the
# segment that starts at 0 and ends at 3 (inclusive). The resulting string
# will be "dcbaefd".
#
# Return the resulting string.
#
# Example 1:
#
#   Input: word = "abcdefd", ch = "d"
#   Output: "dcbaefd"
#   Explanation: The first occurrence of "d" is at index 3.
#   Reverse the part of word from 0 to 3 (inclusive), the resulting string is "dcbaefd".
#
# Example 2:
#
#   Input: word = "xyxzxe", ch = "z"
#   Output: "zxyxxe"
#   Explanation: The first and only occurrence of "z" is at index 3.
#   Reverse the part of word from 0 to 3 (inclusive), the resulting string is "zxyxxe".
#
# Example 3:
#
#   Input: word = "abcd", ch = "z"
#   Output: "abcd"
#   Explanation: "z" does not exist in word.
#   You should not do any reverse operation, the resulting string is "abcd".
#
# Constraints:
#
#     1 <= word.length <= 250
#     word consists of lowercase English letters.
#     ch is a lowercase English letter.

class Solutions
  def self.cheap(word, ch)
    ch_index = word.index(ch)

    return word unless ch_index

    word[0..ch_index].reverse + word[ch_index + 1..]
  end
end

test_cases = [
  {
    params: ["abcdefd", "d"],
    result: "dcbaefd",
  },
  {
    params: ["xyxzxe", "z"],
    result: "zxyxxe",
  },
  {
    params: ["abcd", "z"],
    result: "abcd",
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
  # label: "my friendly label",
)
