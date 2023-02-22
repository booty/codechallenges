# frozen_string_literal: true

require "benchmark/ips"
require "pry-byebug"

test_cases = [
  { number: 0, result: "" },
  { number: 1, result: "I" },
  { number: 2, result: "II" },
  { number: 3, result: "III" },
  { number: 4, result: "IV" },
  { number: 5, result: "V" },
  { number: 6, result: "VI" },
  { number: 7, result: "VII" },
  { number: 8, result: "VIII" },
  { number: 9, result: "IX" },
  { number: 10, result: "X" },
  { number: 20, result: "XX" },
  { number: 52, result: "LII" },
  { number: 69, result: "LXIX" },
  { number: 99, result: "XCIX" },
  { number: 100, result: "C" },
  { number: 999, result: "CMXCIX" },
  { number: 999, result: "CMXCIX" },
  { number: 1999, result: "MCMXCIX" },
  { number: 2123, result: "MMCXXIII" },
  { number: 2999, result: "MMCMXCIX" },
]

class Solutions
  def self.lookups(num)
    results = []

    ones = %w[I X C M]
    fives = ["V", "L", "D", "?"]

    0.upto(3) do |power_of_ten|
      current_digit = num % (10**(power_of_ten + 1)) / (10**power_of_ten)
      one = ones[power_of_ten]
      five = fives[power_of_ten]
      results.push case current_digit
                   when 0
                     ""
                   when 1..3
                     one * current_digit
                   when 4
                     one + five
                   when 5..8
                     five + (one * (current_digit - 5))
                   when 9
                     one + ones[power_of_ten + 1]
                   end
    end

    results.reverse.join
  end
end

(Solutions.methods - Class.methods).each do |meth|
  puts meth
  test_cases.each_with_index do |tcase, _tindex|
    print "  case #{tcase[:number]}"
    actual_result = Solutions.send(meth, tcase[:number])
    if actual_result == tcase[:result]
      puts " ✅ pass (#{actual_result})"
    else
      puts " ❌ fail!"
      puts "    actual: #{actual_result}"
      puts "    expected: #{tcase[:result]}"
    end
  end
end
