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

    follows = Array.new(26) { Array.new(26) }

    maxwordlen = words.map(&:length).max

    0.upto(maxwordlen - 1) do |col|
      putsif "col:#{col}"
      words.each_with_index do |word, row|
        c = word[col]
        putsif "  c:#{c} word:#{word} row:#{row}"

        next unless c

        result << c unless result.index(c)

        # record this relationship
        0.upto(row - 1) do |comp_row|
          comp_char = words[comp_row][col]

          next unless comp_char
          next if c == comp_char

          putsif "    allegedy, #{c} follows #{comp_char}"

          if follows[comp_char.ord - 97][c.ord - 97]
            putsif "    HOWEVER this contradicts previous evidence"
            return ""
          end

          follows[c.ord - 97][comp_char.ord - 97] = true
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
  # {
  #   params: [["zqa", "qb", "ba"]],
  #   result: ""
  # },
  # {
  #   params: [["z", "x"]],
  #   result: "zx",
  # },
  # {
  #   params: [["z", "x", "z"]],
  #   result: "",
  # },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(actual_result, expected_result) {
  #   actual_result.to_set == expected_result.to_set
  # },
  # label: "my friendly label",
)
