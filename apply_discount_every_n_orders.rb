# frozen_string_literal: true

require_relative "common/testrunner"

#  1357. Apply Discount Every n Orders Medium 166 210 company Facebook
#
#  There is a supermarket that is frequented by many customers. The products sold
#  at the supermarket are represented as two parallel integer arrays products and
#  prices, where the ith product has an ID of products[i] and a price of prices
#  [i].
#
#  When a customer is paying, their bill is represented as two parallel integer
#  arrays product and amount, where the jth product they purchased has an ID of
#  product[j], and amount[j] is how much of the product they bought. Their
#  subtotal is calculated as the sum of each amount[j] * (price of the jth
#  product).
#
#  The supermarket decided to have a sale. Every nth customer paying for their
#  groceries will be given a percentage discount. The discount amount is given by
#  discount, where they will be given discount percent off their subtotal. More
#  formally, if their subtotal is bill, then they would actually pay bill * (
#  (100 - discount) / 100).
#
#  Implement the Cashier class:
#
# Cashier(int n, int discount, int[] products, int[] prices) Initializes the
# object with n, the discount, and the products and their prices. double
# getBill(int[] product, int[] amount) Returns the final total of the bill
# with the discount applied (if any). Answers within 10-5 of the actual value
# will be accepted.
#
#
#
#  Example 1:
#
#  Input
#  ["Cashier","getBill","getBill","getBill","getBill","getBill","getBill","getBill"]
#  [[3,50,[1,2,3,4,5,6,7],[100,200,300,400,300,200,100]],[[1,2],[1,2]],[[3,7],[10,10]],[[1,2,3,4,5,6,7],[1,1,1,1,1,1,1]],[[4],[10]],[[7,3],[10,10]],[[7,5,3,1,6,4,2],[10,10,10,9,9,9,7]],[[2,3,5],[5,3,2]]]
#
#
#
#  Constraints:
#
# 1 <= n <= 104 0 <= discount <= 100 1 <= products.length <= 200 prices.length
# == products.length 1 <= products[i] <= 200 1 <= prices[i] <= 1000 The
# elements in products are unique. 1 <= product.length <= products.length
# amount.length == product.length product[j] exists in products. 1 <= amount
# [j] <= 1000 The elements of product are unique. At most 1000 calls will be
# made to getBill. Answers within 10-5 of the actual value will be accepted.
#

class Cashier
  attr_accessor :n, :discount, :products, :prices, :customer_number

  # :type n: Integer
  # :type discount: Integer
  # :type products: Integer[]
  # :type prices: Integer[]
  def initialize(n, discount, products, prices)
    @n = n
    @discount = discount
    @products = products
    @prices = prices
    @customer_number = 0
  end

  # :type product: Integer[]
  # :type amount: Integer[]
  # :rtype: Float
  def get_bill(product, amount)
    @customer_number += 1
    subtotal = 0
    product.each_with_index do |product_id, i|
      product_index = @products.index(product_id)
      product_price = @prices[product_index]

      subtotal += product_price * amount[i]
    end
    if @customer_number % n == 0
      subtotal * ((100.to_f - discount.to_f) / 100.to_f)
    else
      subtotal
    end
  end
end
