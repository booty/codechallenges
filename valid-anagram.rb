# frozen_string_literal: true

require_relative "testrunner"

class Solutions
  # While theoretically faster than #lazy_each_char in reality
  # this is more than twice as slow, probably because
  # methods like #each_char, #to_a, and #sort are implemented in C
  def self.histogram(s, t)
    return false unless s.length == t.length

    hist = Hash.new(0)

    0.upto(s.length - 1) do |i|
      hist[s[i]] += 1
      hist[t[i]] -= 1
    end

    hist.values.all?(&:zero?)
  end

  def self.lazy_each_char(s, t)
    return false unless s.length == t.length

    s.each_char.to_a.sort == t.each_char.to_a.sort
  end
end

VALID_CHARS = ("a".."z").to_a

LONG_RANDOM_STRING_1 = VALID_CHARS.sample(10_000_000).join

LONG_RANDOM_STRING_1_SHUFFLED = LONG_RANDOM_STRING_1.chars.shuffle.join

LONG_RANDOM_STRING_2 = LONG_RANDOM_STRING_1.upcase

test_cases = [
  {
    params: ["rat", "car"],
    result: false,
  },
  {
    params: ["brat", "bart"],
    result: true,
  },
  {
    params: [LONG_RANDOM_STRING_1, LONG_RANDOM_STRING_1_SHUFFLED],
    result: true,
    label: "long (shuffled)",
  },
  {
    params: [LONG_RANDOM_STRING_1, LONG_RANDOM_STRING_2],
    result: false,
    label: "long (diff string)",
  }
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
  # custom_comparison: ->(a, b) { a.to_set == b.to_set },
  # label: "my friendly label",
)
