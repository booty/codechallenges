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

# require_relative "strong_password_checker_password"

class Solutions
  def self.first(password)
    upper_needed = 1
    lower_needed = 1
    digit_needed = 1
    other_count = 0
    triples = 0
    triples_fixable_by_deletion = 0
    changes = 0
    previous_c = nil
    consecutive = 1

    putsif "--- begin (#{password} len:#{password.length}) ---"

    password.chars.each_with_index do |c, i|
      case c
      when "A".."Z"
        upper_needed = 0
      when "a".."z"
        lower_needed = 0
      when "0".."9"
        digit_needed = 0
      else
        other_count += 1
      end

      consecutive += 1 if c == previous_c

      # we've reached the end of a run because we hit a mismatch OR end of string
      if (c != previous_c) || i == (password.length - 1)
        putsif "  hit the end of a streak consecutive:#{consecutive}"
        if consecutive >= 3
          triples += consecutive / 3
          triples_fixable_by_deletion += 1
          putsif "   now: triples:#{triples} " \
                 "changes:#{changes} triples_fixable_by_deletion:#{triples_fixable_by_deletion}"
        end
        consecutive = 1
      end

      previous_c = c
    end

    char_classes_needed = upper_needed + lower_needed + digit_needed

    putsif "char_classes_needed:#{char_classes_needed} triples:#{triples}"

    # The most "efficient" thing we can do is add a character.
    # This can kill 1, 2, or 3 birds with one stone because it can provide missing
    # length and/or break up a triplet and/or provide a missing character class
    # ex: AA111 (1 triplet, 1 character classes needed, 1 missing character)
    #     could become (1 change)
    #     AA1a11 (0 triples, 0 character classes needed, 0 missing character)
    # ex: .!. (0 triples, 3 character classes needed, 3 missing character)
    #     could become (3 changes)
    #     .!.aA1 (0 triples, 0 character classes needed, 0 missing characters)
    if (missing_length = (6 - password.length)).positive?
      char_classes_needed -= missing_length
      char_classes_needed = 0 if char_classes_needed.negative?
      triples -= missing_length
      triples = 0 if triples.negative?

      changes += missing_length
      putsif "added #{missing_length} missing length"
      putsif "   now: char_classes_needed:#{char_classes_needed} triples:#{triples} " \
             "changes:#{changes} triples_fixable_by_deletion:#{triples_fixable_by_deletion}"
    end

    # If the string is too long, we can kill two birds with one stone
    # and delete characters that will break up the triples
    # ex: 01234567890123456AAAaaa (2 triples, 22 characters)
    #     could become (2 changes)
    #     01234567890123456AAaa (0 triples, 20 characters)
    #
    # TODO:
    #
    # Not all triples can be fixed by deletion.
    # ex: aaaaaaaaaaaaaaaaaaaaa (23 characters, 7 triples)
    #     could become (3 changes)
    #     aaaaaaaaaaaaaaaaaa (20 characters, 6 triples)
    #     we delete 3 characters, but we have only reduced triples by 1
    if (extra_length = (password.length - 20)).positive?
      triples -= [extra_length, triples_fixable_by_deletion].min
      triples = 0 if triples.negative?

      changes += extra_length
      putsif "deleted #{extra_length} extra_length"
      putsif "   now: char_classes_needed:#{char_classes_needed} triples:#{triples} " \
             "changes:#{changes} triples_fixable_by_deletion:#{triples_fixable_by_deletion}"
    end

    # If we have remaining triples we can break
    # them up by changing characters to provided needed classes
    # ex: 000111222 (3 triples, 2 needed char classes)
    #     could become (2 changes)
    #     000A11a22 (1 triple, 0 needed char classes)
    # ex: ...!!! (2 triples, 3 needed char classes)
    #     could become (3 changes)
    #     aA.1!! (0 triples, 0 needed char classes)
    if char_classes_needed.positive?
      triples -= char_classes_needed
      triples = 0 if triples.negative?

      putsif "will change #{char_classes_needed} to provide missing classes"
      changes += char_classes_needed
      char_classes_needed = 0
      putsif "   now: char_classes_needed:#{char_classes_needed} triples:#{triples} " \
             "changes:#{changes} triples_fixable_by_deletion:#{triples_fixable_by_deletion}"
    end

    # If we have remaining triples, break them up
    if triples.positive?
      char_classes_needed -= triples
      char_classes_needed = 0 if char_classes_needed.negative?

      putsif "need to fix #{triples} triples"
      changes += triples
      triples = 0
      putsif "   now: char_classes_needed:#{char_classes_needed} triples:#{triples} " \
             "changes:#{changes} triples_fixable_by_deletion:#{triples_fixable_by_deletion}"
    end

    changes
  end
end

test_cases = [
  {
    params: ["a"],
    result: 5,
  },
  {
    params: ["aA1"],
    result: 3,
  },
  {
    params: ["1337C0d3"],
    result: 0,
  },
  {
    params: ["z"],
    result: 5,
  },
  {
    params: ["aa123"],
    result: 1,
  },
  {
    params: ["aaaB1"],
    result: 1,
  },
  {
    params: ["aaa111"],
    result: 2,
  },
  {
    params: ["aaAA11"],
    result: 0,
  },
  {
    params: ["1111111111"],
    result: 3,
  },
  {
    params: ["bbaaaaaaaaaaaaaaacccccc"],
    result: 8,
  },
  {
    params: ["FFFFFFFFFFFFFFF11111111111111111111AAA"],
    result: 23,
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
  # label: "my friendly label",
)
