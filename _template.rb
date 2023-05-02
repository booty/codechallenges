# frozen_string_literal: true

require "pry-byebug"
require "benchmark/ips"

BM_WARMUP_SECONDS = 0.5
BM_TIME_SECONDS = 2

class Solutions
  def self.faster(str, reps)
    str.reverse * reps
  end

  def self.slower(str, reps)
    str.reverse.reverse.reverse.reverse.reverse * reps
  end

  def self.wtf(str, reps)
    result = []
    reps.times do
      str.length.downto(1).each do |i|
        result << str[i - 1]
      end
    end
    result.join
  end
end

test_cases = [
  { input: "abc", reps: 3, result: "cbacbacba" },
  { input: "hello", reps: 2, result: "olleholleh" },
]

def benchmark_label(method_name, test_case)
  "#{method_name} (#{test_case.except(:result).values.join(', ')[0..20]})"
end

Benchmark.ips do |bm|
  bm.config(time: BM_TIME_SECONDS, warmup: BM_WARMUP_SECONDS)
  methods = (Solutions.methods - Class.methods)
  methods.each do |meth|
    puts meth
    test_cases.each_with_index do |tcase, _tindex|
      print "  case #{tcase[:input]}"

      work = lambda { Solutions.send(meth, tcase[:input], tcase[:reps]) }
      actual_result = work.call

      if actual_result == tcase[:result]
        puts " ✅ pass (#{actual_result})"
      else
        puts " ❌ fail!"
        puts "    actual: #{actual_result}"
        puts "    expected: #{tcase[:result]}"
      end

      label = benchmark_label(meth, tcase)
      bm.report(label) { work.call }
    end
  end
end
