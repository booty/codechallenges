# frozen_string_literal: true

require_relative "common/testrunner"

# 2109. Adding Spaces to a String (Medium)
#
# https://leetcode.com/problems/adding-spaces-to-a-string/description/
#
# You are given a 0-indexed string s and a 0-indexed integer array spaces that
# describes the indices in the original string where spaces will be added. Each
# space should be inserted before the character at the given index.
#
#     For example, given s = "EnjoyYourCoffee" and spaces = [5, 9], we place
#     spaces before 'Y' and 'C', which are at indices 5 and 9 respectively. Thus,
#     we obtain "Enjoy Your Coffee".
#
# Return the modified string after the spaces have been added.
#
# Example 1:
#
# Input: s = "LeetcodeHelpsMeLearn", spaces = [8,13,15]
# Output: "Leetcode Helps Me Learn"
# Explanation: The indices 8, 13, and 15 correspond to the underlined
# characters in "LeetcodeHelpsMeLearn". We then place spaces before those
# characters.
#
# Example 2:
#
# Input: s = "icodeinpython", spaces = [1,5,7,9]
# Output: "i code in py thon"
# Explanation: The indices 1, 5, 7, and 9 correspond to the underlined characters
# in "icodeinpython". We then place spaces before those characters.
#
# Example 3:
#
# Input: s = "spacing", spaces = [0,1,2,3,4,5,6]
# Output: " s p a c i n g"
# Explanation: We are also able to place spaces before the first character of the
# string.
#
# Constraints:
#
#     1 <= s.length <= 3 * 105 s consists only of lowercase and uppercase English
#     letters. 1 <= spaces.length <= 3 * 105 0 <= spaces[i] <= s.length - 1 All
#     the values of spaces are strictly increasing.

class Solutions
  # too slow
  def self.concats(s, spaces)
    spaces_pointer = 0
    result = ""

    s.chars.each_with_index do |c, index|
      if index == spaces[spaces_pointer]
        result += " "
        spaces_pointer += 1
      end
      result += c
    end
    result
  end

  # accepted
  def self.prealloc(s, spaces)
    spaces_pointer = 0
    write_pointer = 0
    result = " " * (s.length + spaces.length)

    s.chars.each_with_index do |c, index|
      if index == spaces[spaces_pointer]
        spaces_pointer += 1
        write_pointer += 1
      end
      result[write_pointer] = c
      write_pointer += 1
    end
    result
  end

  # borrowed from https://leetcode.com/problems/adding-spaces-to-a-string/solutions/3128035/sort-and-reverse-the-array-then-just-loop-through-and-insert-the-spaces-at-the-index/
  # several times faster than prealloc for small strings
  # but much slower for large strings and/or lots of spaces
  def self.borrowed(s, spaces)
    dup = s.dup
    a = spaces.reverse
    a.each do |i|
      dup.insert(i, " ")
    end
    dup
  end
end

test_cases = [
  {
    params: ["LeetcodeHelpsMeLearn", [8, 13, 15]],
    result: "Leetcode Helps Me Learn",
  },
  {
    params: ["spacing", [0, 1, 2, 3, 4, 5, 6]],
    result: " s p a c i n g",
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
  # label: "my friendly label",
)
