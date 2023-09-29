# frozen_string_literal: true

require "benchmark/ips"

test_cases = [
  {
    number: 123,
    result: false,
  },
  {
    number: -9_834_793_847,
    result: false,
  },
  {
    number: 0,
    result: true,
  },
  {
    number: 8,
    result: true,
  },
  {
    number: 2**31,
    result: false,
  },
  {
    number: 2_123_443_212,
    result: true,
  },
  {
    number: 1_234_321,
    result: true,
  },
  {
    number: 123_421,
    result: false,
  },
  {
    number: 100,
    result: false,
  },
]

class Solutions
  def self.string_rev_naive(num)
    num.to_s.reverse == num.to_s
  end

  def self.string_rev_opt1(num)
    foo = num.to_s
    foo == foo.reverse
  end

  def self.string_rev_opt2(num)
    return false if num.negative?
    return true if num < 10
    return false if (num % 10).zero?

    foo = num.to_s
    foo == foo.reverse
  end

  def self.string_no_rev(num)
    return false if num.negative?
    return true if num < 10

    str = num.to_s
    0.upto(str.length / 2) do |i|
      return false unless str[i] == str[0 - (i + 1)]
    end
    true
  end

  def self.no_string(num)
    return false if num.negative?
    return true if num < 10

    digits = []
    last_digit = 0

    1.upto(31) do |i|
      raw = num % (10**i)
      raw2 = num % (10**(i - 1))
      raw3 = (raw - raw2) / (10**(i - 1))
      # puts "i:#{i} raw:#{raw} raw3:#{raw3} #{10**(i-1)}"
      digits.push(raw3)
      last_digit = i if raw3.positive?
    end
    digits = digits[0..last_digit - 1]

    digits == digits.reverse
  end

  def self.stolen(num)
    return false if num.negative?
    return true if num < 10

    num.to_s == num.to_s.reverse
  end
end

(Solutions.methods - Class.methods).each do |meth|
  puts meth
  test_cases.each do |tcase|
    print "  case #{tcase[:number]} "
    actual_result = Solutions.send(meth, tcase[:number])
    if actual_result == tcase[:result]
      puts "✅ pass"
    else
      puts "❌ fail!"
      puts "actual: #{actual_result}"
      puts "expected: #{tcase[:result]}"
    end
  end
end

Benchmark.ips do |x|
  x.config(time: 1, warmup: 0.5)
  (Solutions.methods - Class.methods).each do |meth|
    x.report(meth) do
      test_cases.each do |tcase|
        tcase[:result] = Solutions.send(meth, tcase[:number])
      end
    end
  end
end

# def bar(num)
#   return false if num < 0
#   return true if num < 10
#   digits = []
#   last_digit = 0

#   1.upto(31) do |i|
#     raw = num % 10**(i)
#     raw2 = num % 10**(i-1)
#     raw3 = (raw - raw2) / (10**(i-1))
#     # puts "i:#{i} raw:#{raw} raw3:#{raw3} #{10**(i-1)}"
#     digits.push(raw3)
#     last_digit = i if raw3 > 0
#   end
#   digits = digits[0..last_digit - 1]

#   digits == digits.reverse
# end
