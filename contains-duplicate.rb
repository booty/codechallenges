# frozen_string_literal: true

require_relative "testrunner"

class Solutions
  def self.contains_duplicate(nums)
    hist = {}
    nums.each do |x|
      return true if hist[x]

      hist[x] = 42
    end
    false
  end
end

test_cases = [
  {
    params: [[1, 2, 3, 1]],
    result: true,
  },
  {
    params: [[1, 2, 3, 4]],
    result: false,
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
  # label: "my friendly label",
)
