# frozen_string_literal: true

#
# https://leetcode.com/problems/best-time-to-buy-and-sell-stock/
#
# You are given an array prices where prices[i] is the price of a given stock on the ith day.
# You want to maximize your profit by choosing a single day to buy one stock and
# choosing a different day in the future to sell that stock.
#
# Return the maximum profit you can achieve from this transaction. If you cannot
# achieve any profit, return 0.
#
# Example 1:
#
# Input: prices = [7,1,5,3,6,4]
# Output: 5
# Explanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6),
#   profit = 6-1 = 5. Note that buying on day 2 and selling on day 1
#   is not allowed because you must buy before you sell.
#
# Example 2:
#
#   Input: prices = [7,6,4,3,1]
#   Output: 0
#   Explanation: In this case, no transactions are done and the max profit = 0.
#
# Constraints:
#
#     1 <= prices.length <= 105 0 <= prices[i] <= 104
#

require_relative "common/testrunner"

class Solutions
  # O(n) time, 0(n) space
  def self.mappy1pass(prices)
    max_price = 0
    max_profit = 0
    (prices.length - 1).downto(1) do |day|
      max_price = prices[day] if prices[day] > max_price

      profit = max_price - prices[day - 1]
      max_profit = profit if profit > max_profit
    end
    max_profit
  end

  # O(2n) time, 0(2n) space
  def self.mappy(prices)
    max_price_after_day_n = Array.new(prices.length)

    max_price = 0
    (prices.length - 1).downto(0) do |day|
      max_price = prices[day] if prices[day] > max_price

      max_price_after_day_n[day] = max_price
    end

    max_profit = 0
    prices.each_with_index do |price, day|
      profit = max_price_after_day_n[day] - price

      max_profit = profit if profit > max_profit
    end
    max_profit
  end

  def self.ary(prices)
    pricemap = []
    prices.each_with_index do |price, index|
      pricemap << [price, index]
    end
    pricemap.sort!
    pricemap.reverse!

    max_profit = 0

    # putsif "pricemap:#{pricemap}"
    prices.each_with_index do |price, index|
      match = pricemap.detect { |y| (y[1] > index) && (y[0] > price) }
      # putsif "  index:#{index} price:#{price} match:#{match}"

      next unless match

      profit = (match[0] - price)
      # putsif "  profit:#{profit}"
      max_profit = profit if profit > max_profit
    end

    max_profit
  end

  # this is O(n * n/2)ish 👎
  def self.naive(prices)
    max_profit = 0

    prices.each_index do |buy_index|
      (buy_index + 1).upto(prices.length - 1) do |sell_index|
        profit = prices[sell_index] - prices[buy_index]
        # putsif "buy_index:#{buy_index} sell_index:#{sell_index} profit:#{profit}"

        max_profit = [profit, max_profit].max
      end
    end

    max_profit
  end
end

test_cases = [
  {
    params: [[7, 1, 5, 3, 6, 4]],
    result: 5,
  },
  {
    params: [[7, 6, 4, 3, 1]],
    result: 0,
  },
  {
    params: [(1..1000).to_a.reverse],
    result: 0,
    silent: true,
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
)
