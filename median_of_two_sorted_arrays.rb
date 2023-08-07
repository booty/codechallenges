# frozen_string_literal: true

# https://leetcode.com/problems/median-of-two-sorted-arrays/
# This is ranked "hard" but, presumably that's for languages that
# don't have built-in array merging and sorting like Ruby

require "pry-byebug"
require "benchmark/ips"

BM_WARMUP_SECONDS = 0.5
BM_TIME_SECONDS = 2
DEBUG = false

class Solutions
  def self.naive(nums1, nums2)
    nums3 = (nums1 + nums2).sort

    if nums3.length.odd?
      nums3[nums3.length / 2]
    else
      (nums3[nums3.length / 2] + nums3[(nums3.length / 2) - 1]) / 2.0
    end
  end
end

test_cases = [
  { input: [[1, 3], [2]], result: 2 },
  { input: [[1, 2], [3, 4]], result: 2.5 },
]

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

      work = lambda { Solutions.send(meth, tcase[:input][0], tcase[:input][1]) }
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
