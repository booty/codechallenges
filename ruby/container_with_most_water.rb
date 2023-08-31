# frozen_string_literal: true

require "pry-byebug"
require "benchmark/ips"

BM_WARMUP_SECONDS = 0.5
BM_TIME_SECONDS = 2
DEBUG = true

class Solutions
  def self.move_inward(height)
    left = 0
    right = height.length - 1
    solution = { left: nil, right: nil, volume: 0 }

    while right > left
      h_left = height[left]
      h_right = height[right]
      distance = right - left
      volume = [h_left, h_right].min * distance
      putsif "right:#{right} left:#{left} distance:#{distance} volume:#{volume}"

      if volume > solution[:volume]
        solution = { left:, right:, volume: }
      end

      if h_left <= h_right
        left += 1
      else
        right -= 1
      end
    end

    putsif solution

    solution[:volume]
  end

  def self.naive(height)
    solution = { index1: nil, index2: nil, volume: 0 }
    height.each_with_index do |h1, i1|
      putsif "i1:#{i1} h1:#{h1}"
      height[i1..].each_with_index do |h2, distance|
        volume = [h1, h2].min * distance
        putsif "  h2:#{h2} distance:#{distance} volume:#{volume}"

        if volume > solution[:volume]
          putsif "    new solution"
          solution = { index1: h1, index2: h2, volume: }
        end
      end
    end

    solution[:volume]
  end
end

test_cases = [
  { input: [1, 8, 6, 2, 5, 4, 8, 3, 7], result: 49 },
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
