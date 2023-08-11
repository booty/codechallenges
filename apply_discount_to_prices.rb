# frozen_string_literal: true

require_relative "common/testrunner"

# 2288. Apply Discount to Prices (Medium)
#
# https://leetcode.com/problems/apply-discount-to-prices/
#
# A sentence is a string of single-space separated words where each word can
# contain digits, lowercase letters, and the dollar sign '$'. A word represents a
# price if it is a sequence of digits preceded by a dollar sign.
#
#     For example, "$100", "$23", and "$6" represent prices while "100", "$",
#     and "$1e5" do not.
#
# You are given a string sentence representing a sentence and an integer discount.
# For each word representing a price, apply a discount of discount% on the price
# and update the word in the sentence. All updated prices should be represented
# with exactly two decimal places.
#
# Return a string representing the modified sentence.
#
# Note that all prices will contain at most 10 digits.
#
# Example 1:
#
# Input: sentence = "there are $1 $2 and 5$ candies in the shop", discount = 50
# Output: "there are $0.50 $1.00 and 5$ candies in the shop"
# Explanation: The words which represent prices are "$1" and "$2".
# - A 50% discount on "$1" yields "$0.50", so "$1" is replaced by "$0.50".
# - A 50% discount on "$2" yields "$1". Since we need to have exactly 2 decimal
#   places after a price, we replace "$2" with "$1.00".
#
# Example 2:
#
# Input: sentence = "1 2 $3 4 $5 $6 7 8$ $9 $10$", discount = 100ptestrunn
# Output: "1 2 $0.00 4 $0.00 $0.00 7 8$ $0.00 $10$"
# Explanation: Applying a 100% discount on any price will result in 0.
# The words representing prices are "$3", "$5", "$6", and "$9".
# Each of them is replaced by "$0.00".
#
# Constraints:
#
#     1 <= sentence.length <= 10^5
#     sentence consists of lowercase English letters, digits, ' ', and '$'.
#     sentence does not have leading or trailing spaces.
#     All words in sentence are separated by a single space.
#     All prices will be positive numbers without leading zeros.
#     All prices will have at most 10 digits.
#     0 <= discount <= 100

class Solutions
  # def self.regex(sentence, discount)
  #   regex = /(\$[0-9]+\.*[0-9]*)/
  #   result = ""
  #   sentence.scan(regex).each do |match|
  #     price = match[0][1..].to_f
  #     discount_amt = (discount.to_f / 100) * price
  #     new_price = (price - discount_amt).round(2)
  #     putsif "match:#{match} "
  #     result = sentence.gsub(match[0], "$#{new_price}")
  #   end
  #   result
  # end

  def self.regex(sentence, discount)
    regex = /\A\$[0-9]+\.*[0-9]*\z/

    result = []

    sentence.split.each do |word|
      putsif "word:#{word}"

      unless word.match?(regex)
        result << word
        next
      end

      old_price = word[1..].to_f
      discount_amt = old_price * (discount.to_f / 100)
      new_price = old_price - discount_amt

      putsif "  old_price:#{old_price} discount:#{discount} new_price:#{new_price}"

      result << "$#{sprintf('%.2f', new_price)}"
    end

    result.join(" ")
  end
end

test_cases = [
  {
    params: ["there are $1 $2 and 5$ candies in the shop", 50],
    result: "there are $0.50 $1.00 and 5$ candies in the shop",
  },
  {
    params: ["1 2 $3 4 $5 $6 7 8$ $9 $10$", 100],
    result: "1 2 $0.00 4 $0.00 $0.00 7 8$ $0.00 $10$",
  },
  {
    params: ["$2$3 $10 $100 $1 200 $33 33$ $$ $99 $99999 $9999999999", 0],
    result: "$2$3 $10.00 $100.00 $1.00 200 $33.00 33$ $$ $99.00 $99999.00 $9999999999.00",
  }
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(actual_result, expected_result) {
  #   actual_result.to_set == expected_result.to_set
  # },
  # label: "my friendly label",
)
