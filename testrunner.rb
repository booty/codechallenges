require "pry-byebug"
require "benchmark/ips"

BM_WARMUP_SECONDS = 0.5
BM_TIME_SECONDS = 2

class String
  def ellipsize(limit)
    return self if length <= limit

    "#{self[0..limit - 2]}…"
  end
end

def putsif(str)
  puts str if DEBUG
end

class TestRunner
  def benchmark_label(method_name, test_case)
    "#{method_name}(#{test_case.except(:result).values.join(',').ellipsize(15)})"
  end

  def run(solutions_klass:, test_cases:, custom_comparison: nil)
    Benchmark.ips do |bm|
      bm.config(time: BM_TIME_SECONDS, warmup: BM_WARMUP_SECONDS)
      methods = (solutions_klass.methods - Class.methods)
      methods.each do |method_name|
        puts "method: #{method_name}"
        test_cases.each do |tcase|
          puts "  case: #{tcase[:params]}"

          work = lambda {
            solutions_klass.send(method_name, *tcase[:params])
          }

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

          if is_correct
            puts "    ✅ pass"
          else
            puts "    ❌ fail!"
            puts "       actual: #{actual_result}"
            puts "       expected: #{expected_result}"
          end

          label = benchmark_label(method_name, tcase)
          bm.report(label) { work.call } unless DEBUG
        end
      end
    end
  end
end
