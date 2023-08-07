# frozen_string_literal: true

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

  def assert_equal(expected, actual, description = "")
    record_and_display_result TestResult.new(
      success: expected == actual,
      description:,
      details: ["expected: #{expected}", "actual: #{actual}"],
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

    icon = failed.zero? ? "😎" : "💀"
    "#{format_method_name('RESULTS')}\n  #{icon} passed:#{passed} failed:#{failed}\n\n"
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