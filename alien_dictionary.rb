# frozen_string_literal: true

require_relative "common/testrunner"

# 269. Alien Dictionary (Hard)
#
# https://leetcode.com/problems/alien-dictionary/
#
# There is a new alien language that uses the English alphabet. However, the order
# of the letters is unknown to you.
#
# You are given a list of strings words from the alien language's dictionary. Now
# it is claimed that the strings in words are sorted lexicographically by the
# rules of this new language.
#
# If this claim is incorrect, and the given arrangement of string in words cannot
# correspond to any order of letters, return "".
#
# Otherwise, return a string of the unique letters in the new alien language
# sorted in lexicographically increasing order by the new language's rules. If
# there are multiple solutions, return any of them.
#
# Example 1:
#
# Input: words = ["wrt","wrf","er","ett","rftt"]
# Output: "wertf"
#
# Example 2:
#
# Input: words = ["z","x"]
# Output: "zx"
#
# Example 3:
#
# Input: words = ["z","x","z"]
# Output: "" Explanation: The order is invalid, so
# return "".
#
# Constraints:
#
# 1 <= words.length <= 100 1 <= words[i].length <= 100 words[i] consists of
# only lowercase English letters.

class Solutions
  def self.arrays(words)
    result = []

    maxlen = words.map(&:length).max

    0.upto(maxlen - 1) do |pos|
      # get letters from this column
      col = []
      words.each do |word|
        col << word[pos]
      end
      col.uniq!

      col.each do |c|
        if result.empty? || result.index(c).nil?
          result << c
        end
      end
    end

    result.join
  end
end

test_cases = [
  {
    params: [["wrt", "wrf", "er", "ett", "rftt"]],
    result: "wertf",
  },
  {
    params: [["z", "x"]],
    result: "zx",
  },
  {
    params: [["z", "x", "z"]],
    result: "",
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(actual_result, expected_result) {
  #   actual_result.to_set == expected_result.to_set
  # },
  # label: "my friendly label",
)
