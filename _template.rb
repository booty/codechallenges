# frozen_string_literal: true

require_relative "testrunner"

class Solutions
  def self.always_true(_n)
    true
  end
end

test_cases = [
  {
    params: [42],
    result: true,
  },
  {
    params: [-1],
    result: true,
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
  # label: "my friendly label",
)
