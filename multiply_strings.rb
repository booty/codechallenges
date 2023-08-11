# frozen_string_literal: true

require_relative "common/testrunner"

# 43. Multiply Strings (Medium)
#
# https://leetcode.com/problems/multiply-strings/description/
#
# Given two non-negative integers num1 and num2 represented as strings, return the
# product of num1 and num2, also represented as a string.
#
# Note: You must not use any built-in BigInteger library or convert the inputs to
# integer directly.
#
# Example 1:
#
# Input: num1 = "2", num2 = "3" Output: "6"
#
# Example 2:
#
# Input: num1 = "123", num2 = "456" Output: "56088"
#
# Constraints:
#
#     - 1 <= num1.length, num2.length <= 200
#     - num1 and num2 consist of digits only.
#     - Both num1 and num2 do not contain any leading zero, except the number 0
#     itself.

class Solutions
  def self.serious(num1, num2)
    sum = 0
    (num2.length - 1).downto(0) do |n2idx|
      n2val = num2[n2idx].to_i * (10**(num2.length - n2idx - 1))
      (num1.length - 1).downto(0) do |n1idx|
        n1val = num1[n1idx].to_i * (10**(num1.length - n1idx - 1))
        sum += (n2val * n1val)
      end
    end
    sum.to_s
  end

  def self.cheat(num1, num2)
    (num1.to_i * num2.to_i).to_s
  end
end

test_cases = [
  {
    params: ["2", "3"],
    result: "6",
  },
  {
    params: ["123", "456"],
    result: "56088",
  },
  {
    params: ["123", "45"],
    result: "5535",
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
