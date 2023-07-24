# frozen_string_literal: true

require_relative "testrunner"

# https://leetcode.com/problems/valid-palindrome/
#
# A phrase is a palindrome if, after converting all uppercase letters into
# lowercase letters and removing all non-alphanumeric characters, it reads the
# same forward and backward. Alphanumeric characters include letters and
# numbers.
#
# Given a string s, return true if it is a palindrome, or false otherwise.
#
# Example 1:
#
# Input: s = "A man, a plan, a canal: Panama" Output: true
# Explanation: "amanaplanacanalpanama" is a palindrome.
#
# Example 2:
#
# Input: s = "race a car" Output: false Explanation: "raceacar" is not a
# palindrome.
#
# Example 3:
#
# Input: s = " " Output: true Explanation: s is an empty string "" after removing
# non-alphanumeric characters. Since an empty string reads the same forward and
# backward, it is a palindrome.
#
#
# Constraints:
#
#  - 1 <= s.length <= 2 * 10^5
#  - s consists only of printable ASCII characters.

class Solutions
  def self.pointers(s)
    regex = /[^a-z0-9]/
    normalized = s.downcase.gsub(regex, "")
    pointer = 0
    len = normalized.length
    return true if len < 2

    0.upto(normalized.length / 2) do |i|
      return false if normalized[i] != normalized[len - 1 - i]
    end
    true
  end

  def self.cheat(s)
    normalized = s.downcase.gsub(/[^a-z0-9]/, "")

    normalized == normalized.reverse
  end
end

test_cases = [
  {
    params: ["A man, a plan, a canal: Panama"],
    result: true,
  },
  {
    params: ["asoiducnasioducnasodiucnasodiucnasodiucnasioudcnaosiducasodiucnaosiudcnoaidfuvndfgvbbvgfdnvufdiaoncduisoancuidosacudisoancduoisancuidosancuidosancuidosancudoisancudiosa"],
    result: true,
  },
  {
    params: ["asoiducnasioducnasodiucnasodiucnasodiucnasioudcnaosiducasodiucnaosiudcnoaidfuvndfgvbbzgfdnvufdiaoncduisoancuidosacudisoancduoisancuidosancuidosancuidosancudoisancudiosa"],
    result: false,
  },
  {
    params: ["zasoiducnasioducnasodiucnasodiucnasodiucnasioudcnaosiaklajs kljcas dlkcjasdljkcnasdkljc adklj dfklvj dfkljvsdfkljvnsdfkljvnsdasdjh casdhj asdjkhasdjkhiujuidfvdf vidfhjkl sdfjklhvsdflkjv sdfljk sdfkjlsfglkjb fglkjbfgkljbnfgkljasdfv adkljasdkljcasdkcasdlh cakljaerluivuiasuilcnasdk aslkj acslkjsdcnaskldjncaklsj flkjdf vklsdfjsdfjklvsdfklj vsdflkjfv lksjdfvnsdfkljvvdf sdfkljvnsdfvjklsdfnklvjnsdfv kljsdfklsdfj sdfv fjdfkvsnsdfjklv klsdfjvklsdfjv slkdfjv lsdfjkv sdklfjv sdfkljv dfkljvv iluhnuishdfouihdfvuiohsdfv sidfhjklvslidfjkv skldfjvisldfjnviusdfv uiosdfvuioh8uionviol erj rejkerjknerjkerkj rejk rekj rjkrefgjn rekjg krjeg gjker gkerjg erjk gejkr erjk gerjkg erjkg erjkg ekrjg ekrj gerjkg erjk erjkg erjkjk kjg kejr gkejr gkjer kjg sdfjklvsdfjklvjkldfvjkldvjklnsdkljnsdfklvsdfkljv k vkjaiuweerui vilkilur erviul vkaj dklsj asdklj asdkjlca sdlkfj vdflkjv sdklfjv dfvilujbnfvilufkljvnsdfkljvnsdflksdfgk sdfguisdfguil sdfgv sdfgli;uvnsdfikl;ujsdfv sdflkjvnsdflkjvnsduifjl;vsdflkjvsdfjklv lsdk;fhjv sdfjklvasdfkjlvsdflk vadl;kjncsdl;ikuasdikl;casdlkhjc asdjklhvrtsdfgjh rtasdfgasdl;jk ducasodiucnaosiudcnoaidfuv ndfgvbbvgfdnvufdiaoncduisoancuidos acudisoancduoi sancuidosancuidosan cuidosancudois ancudiosa"],
    result: false,
  },

  {
    params: ["abc"],
    result: false,
  },
  {
    params: ["hello"],
    result: false,
  },
  {
    params: ["abba"],
    result: true,
  },
  {
    params: ["aba"],
    result: true,
  },
  {
    params: [" "],
    result: true,
  },
  {
    params: ["a."],
    result: true,
  },
  {
    params: ["aa."],
    result: true,
  },
  {
    params: ["0z;z   ; 0"],
    result: true,
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
  # label: "my friendly label",
)
