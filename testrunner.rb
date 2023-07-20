# frozen_string_literal: true

# rubocop:disable Style/GlobalVars

require "pry-byebug"
require "benchmark/ips"

BM_WARMUP_SECONDS = 1.5
BM_TIME_SECONDS = 2

# yeah, naughty
$debug_only = ARGV.include? "--debugonly"
$verbose = $debug_only

# also naughty!
class String
  def ellipsize(limit)
    return self if length <= limit

    "#{self[0..limit - 2]}…"
  end
end

def putsif(str)
  puts str if $verbose
end

class TestRunner
  def benchmark_label(method_name, test_case)
    if test_case[:label]
      "#{method_name}(#{test_case[:label]})"
    else
      "#{method_name}(#{test_case.except(:result).values.join(',').ellipsize(15)})"
    end
  end

  def result(is_correct, actual_result, expected_result)
    if is_correct
      "\t✅ pass"
    else
      "\t❌ fail!" \
        "\t\tactual: #{actual_result}" \
        "\t\texpected: #{expected_result}"
    end
  end

  def work_lambda(method_name, solutions_klass, tcase)
    -> {
      $verbose = false if tcase[:silent]
      result = if tcase[:params].respond_to?(:call)
                 solutions_klass.send(method_name, *tcase[:params].call)
               else
                 solutions_klass.send(method_name, *tcase[:params])
               end
      $verbose = $debug_only
      result
    }
  end

  def run(solutions_klass:, test_cases:, custom_comparison: nil)
    Benchmark.ips do |bm|
      bm.config(
        time: BM_TIME_SECONDS,
        warmup: BM_WARMUP_SECONDS,
      )

      (solutions_klass.methods - Class.methods).each do |method_name|
        puts "method: #{method_name}"
        test_cases.each do |tcase|
          label = benchmark_label(method_name, tcase)
          puts "  case: #{label}"

          work = work_lambda(method_name, solutions_klass, tcase)

          actual_result = work.call
          expected_result = tcase[:result]

          is_correct = if custom_comparison
                         custom_comparison.call(
                           actual_result,
                           expected_result,
                         )
                       else
                         actual_result == expected_result
                       end

          puts result(is_correct, actual_result, expected_result)

          bm.report(label) { work.call } unless $debug_only
        end
      end
    end
  end
end

# rubocop:enable Style/GlobalVars
