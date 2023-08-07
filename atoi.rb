# frozen_string_literal: true

require "pry-byebug"
require "benchmark/ips"

BM_WARMUP_SECONDS = 0.5
BM_TIME_SECONDS = 2
DEBUG = false

class Integer
  def self.clamp(lower, upper)
    return lower if self < lower
    return upper if self > upper

    self
  end
end

test_cases = [
  { input: "42", result: 42 },
  { input: "+42", result: 42 },
  { input: "42z", result: 42 },
  { input: "z42", result: 0 },
  { input: "z42z", result: 0 },
  { input: " -42", result: -42 },
  { input: "+-12", result: 0 },
  { input: "-13+8", result: -13 },
  { input: "words and 987", result: 0 },
  { input: "  +  413", result: 0 },
  { input: " ++1", result: 0 },
  { input: " -42     ", result: -42 },
  { input: "4193 with words", result: 4193 },
  { input: "-91283472332", result: -2147483648 },
]

class Solutions
  LOWER_CLAMP = 0 - (2**31)
  UPPER_CLAMP = (2**31) - 1

  def self.cheat(s)
    num_start_pos = nil
    num_end_pos = nil
    negative = nil
    positive = nil

    0.upto(s.length - 1) do |i|
      got_sign = positive || negative

      case s[i]
      when "-"
        break if num_start_pos
        return 0 if got_sign

        negative = true
      when "+"
        break if num_start_pos
        return 0 if got_sign

        positive = true
      when "0".."9"
        num_start_pos ||= i
        num_end_pos = i
      when " "
        break if num_start_pos
        return 0 if got_sign
      else
        break if num_start_pos

        return 0
      end
    end

    result = s[num_start_pos..num_end_pos].to_i
    result = 0 - result if negative
    result.clamp(LOWER_CLAMP, UPPER_CLAMP)
  end

  def self.naive(s)
    num_start_pos = nil
    num_end_pos = nil
    negative = nil
    positive = nil

    0.upto(s.length - 1) do |i|
      putsif "i:#{i}(#{s[i]}) num_start_pos:#{num_start_pos} num_end_pos:#{num_end_pos}"

      got_sign = positive || negative

      case s[i]
      when "-"
        break if num_start_pos
        return 0 if got_sign

        negative = true
      when "+"
        break if num_start_pos
        return 0 if got_sign

        positive = true
      when /\d/
        num_start_pos ||= i
        num_end_pos = i
      when " "
        break if num_start_pos
        return 0 if positive || negative
      else
        break if num_start_pos

        return 0
      end
    end

    num_string = s[num_start_pos..num_end_pos]
    putsif "num_string:#{num_string}"

    result = 0
    1.upto(num_string.length) do |i|
      c = num_string[num_string.length - i]
      putsif "  i:#{i} c:#{c} ...#{c.to_i * (10**(i - 1))}"
      result += c.to_i * (10**(i - 1))
    end
    result = 0 - result if negative
    result.clamp(LOWER_CLAMP, UPPER_CLAMP)
  end
end

def putsif(str)
  puts str if DEBUG
end

class String
  def ellipsize(limit)
    return self if length <= limit

    "#{self[0..limit - 2]}…"
  end
end

def benchmark_label(method_name, test_case)
  "#{method_name}(#{test_case.except(:result).values.join(',').ellipsize(15)})"
end

Benchmark.ips do |bm|
  bm.config(time: BM_TIME_SECONDS, warmup: BM_WARMUP_SECONDS)
  methods = (Solutions.methods - Class.methods)
  methods.each do |meth|
    puts meth
    test_cases.each_with_index do |tcase, _tindex|
      print "  case #{tcase[:input]}"

      work = lambda { Solutions.send(meth, tcase[:input]) }
      actual_result = work.call

      if actual_result == tcase[:result]
        puts " ✅ pass (#{actual_result})"
      else
        puts " ❌ fail!"
        puts "    actual: #{actual_result}"
        puts "    expected: #{tcase[:result]}"
      end

      label = benchmark_label(meth, tcase)
      bm.report(label) { work.call } unless DEBUG
    end
  end
end
