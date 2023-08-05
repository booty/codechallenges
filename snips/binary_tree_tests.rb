require_relative "binary_tree"

module Testable
  class TestResult
    attr_accessor :success, :description, :details

    def initialize(success:, description:, details: [])
      @success = success
      @description = description
      @details = details
    end
  end

  def assert(condition, description)
    record_and_display_result TestResult.new(
      success: condition,
      description:,
    )
  end

  def assert_equal(one, two, description)
    record_and_display_result TestResult.new(
      success: one == two,
      description:,
      details: ["expected: #{one}", "actual: #{two}"],
    )
  end

  def test
    tally = { passed: 0, failed: 0 }

    methods_not_to_test = [:assert, :assert_equal, :test_results, :test]
    methods_to_test = public_methods - Object.new.public_methods - methods_not_to_test

    methods_to_test.each do |method|
      puts format_method_name(method)
      send(method)
    end
    puts format_tally
  end

  private

  def format_tally
    passed = 0
    failed = 0
    @test_results.each do |tr|
      if tr.success
        passed += 1
      else
        failed += 1
      end
    end

    "#{format_method_name('RESULTS')}\npassed:#{passed} failed:#{failed}\n\n"
  end

  def record_and_display_result(test_result)
    @test_results ||= []
    @test_results << test_result

    puts format_test_result(test_result)
  end

  def format_method_name(method)
    "\n----[ #{method} ]----"
  end

  def format_test_result(test_result)
    output = []
    if test_result.success
      output << "  👍 #{test_result.description}"
    else
      output << "  🚫 #{test_result.description}"
      output += test_result.details.map { |d| "       #{d}" }
    end
    output.join("\n")
  end
end

class TestTreeNode
  include Testable

  def simple_test
    assert true, "verify we're not going crazy"
  end

  def another_test
    assert_equal "cat", "dog", "cats are the same as dogs, right?"
    assert true, "reality check"
    assert false, "insanity check"
    assert_equal "john", "john", "am I myself"
  end
end
