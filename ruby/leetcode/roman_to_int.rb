# frozen_string_literal: true

require "benchmark/ips"
require "pry-byebug"

test_cases = [
  { result: 0, input: "" },
  { result: 1, input: "I" },
  { result: 2, input: "II" },
  { result: 3, input: "III" },
  { result: 4, input: "IV" },
  { result: 5, input: "V" },
  { result: 6, input: "VI" },
  { result: 7, input: "VII" },
  { result: 8, input: "VIII" },
  { result: 9, input: "IX" },
  { result: 10, input: "X" },
  { result: 20, input: "XX" },
  { result: 52, input: "LII" },
  { result: 69, input: "LXIX" },
  { result: 99, input: "XCIX" },
  { result: 100, input: "C" },
  { result: 999, input: "CMXCIX" },
  { result: 999, input: "CMXCIX" },
  { result: 1999, input: "MCMXCIX" },
  { result: 2123, input: "MMCXXIII" },
  { result: 2999, input: "MMCMXCIX" },
]

class Solutions
  def self.first_pass(s)
    return 0 if s.empty?

    vals = { "I" => 1, "V" => 5, "X" => 10, "L" => 50, "C" => 100, "D" => 500, "M" => 1000 }

    total = 0
    previous_value = nil
    s.reverse.each_char do |c|
      current_value = vals[c]

      if previous_value.nil? || previous_value <= current_value
        total += current_value
      else previous_value > current_value
           total -= current_value
      end
      # puts "c:#{c} current_value:#{vals[c]} previous_value:#{previous_value} total:#{total}"

      previous_value = current_value
    end
    total
  end
end

(Solutions.methods - Class.methods).each do |meth|
  puts meth
  test_cases.each do |tcase|
    puts "  case #{tcase[:input]}"
    actual_result = Solutions.send(meth, tcase[:input])
    if actual_result == tcase[:result]
      puts " ✅ pass (#{actual_result})"
    else
      puts " ❌ fail!"
      puts "    actual: #{actual_result}"
      puts "    expected: #{tcase[:result]}"
    end
  end
end
