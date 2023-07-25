# frozen_string_literal: true

require_relative "testrunner"

# 420. Strong Password Checker
#
# https://leetcode.com/problems/strong-password-checker/description/
#
# A password is considered strong if the below conditions are all met:
#
#     It has at least 6 characters and at most 20 characters. It contains at least
#     one lowercase letter, at least one uppercase letter, and at least one digit.
#     It does not contain three repeating characters in a row (i.e., "Baaabb0" is
#     weak, but "Baaba0" is strong).
#
# Given a string password, return the minimum number of steps required to make
# password strong. if password is already strong, return 0.
#
# In one step, you can:
#
#     Insert one character to password, Delete one character from password, or
#     Replace one character of password with another character.
#
# Example 1:
#
# Input: password = "a" Output: 5
#
# Example 2:
#
# Input: password = "aA1" Output: 3
#
# Example 3:
#
# Input: password = "1337C0d3" Output: 0
#
# Constraints:
#
#     1 <= password.length <= 50
#     password consists of letters, digits, dot '.' or
#     exclamation mark '!'.

require_relative "strong_password_checker_password"

class Solutions
  def self.first(password)
    Password.new(password).make_strong_2pass!
  end
end

test_cases = [
  # {
  #   params: ["a"],
  #   result: 5,
  # },
  # {
  #   params: ["aA1"],
  #   result: 3,
  # },
  # {
  #   params: ["1337C0d3"],
  #   result: 0,
  # },
  # {
  #   params: ["z"],
  #   result: 5,
  # },
  {
    params: ["aa123"],
    result: 1,
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
  # label: "my friendly label",
)
