# frozen_string_literal: true

require_relative "common/testrunner"

DEBUG = false

# https://leetcode.com/problems/climbing-stairs/editorial/
#
# You are climbing a staircase. It takes n steps to reach the top.
#
# Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?
#
# Example 1:
#
#   Input: n = 2
#   Output: 2
#   Explanation: There are two ways to climb to the top.
#   1. 1 step + 1 step
#   2. 2 steps
#
# Example 2:
#
#   Input: n = 3
#   Output: 3
#   Explanation: There are three ways to climb to the top.
#   1. 1 step + 1 step + 1 step
#   2. 1 step + 2 steps
#   3. 2 steps + 1 step

# from https://github.com/agrberg/unique_permutation/blob/master/lib/unique_permutation.rb
class Array
  def unique_permutation # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    return enum_for(:unique_permutation) unless block_given?

    array_copy = sort
    yield array_copy.dup
    return if size <= 1

    loop do
      j = size - 2
      j -= 1 while j > 0 && array_copy[j] >= array_copy[j + 1]
      break unless array_copy[j] < array_copy[j + 1]

      l = size - 1
      l -= 1 while array_copy[j] >= array_copy[l]

      array_copy[j], array_copy[l] = array_copy[l], array_copy[j]
      array_copy[(j + 1)..] = array_copy[(j + 1)..].reverse

      yield array_copy.dup
    end
  end
end

class Solutions
  def self.naive(n)
    steps = [1] * n
    solutions = [steps.dup]

    while steps.length > 1 && steps.sum >= n
      # foo += 1
      putsif "old:#{steps}"
      steps.shift(2)
      steps.push(2)
      putsif "new:#{steps}"
      if steps.sum == n
        solutions << steps.dup
        putsif " ....ok! pushed #{steps}"
      end
    end

    putsif "solutions:#{solutions}"

    permuted_solutions = []
    solutions.each { |x| permuted_solutions << x.permutation.to_a.uniq }

    permuted_solutions.flatten!(1)
    putsif "permuted_solutions:#{permuted_solutions}"
    permuted_solutions.length
  end

  def self.naive_uniq_perm(n)
    steps = [1] * n
    solution_count = 1

    while steps.length > 1 && steps.sum >= n
      steps.shift(2)
      steps.push(2)
      if steps.sum == n
        solution_count += steps.dup.unique_permutation.to_a.length
      end
    end
    solution_count
  end

  def self.naive_sets(n)
    steps = [1] * n
    solution_count = 1

    while steps.length > 1 && steps.sum >= n
      steps.shift(2)
      steps.push(2)
      if steps.sum == n
        foo = Set.new
        steps.permutation do |x|
          foo.add(x.hash)
        end
        # putsif " ....ok, got #{foo.length}!"
        solution_count += foo.length
      end
    end
    solution_count
  end

  def self.naive_hash_array(n)
    steps = [1] * n
    solution_count = 1

    while steps.length > 1 && steps.sum >= n
      steps.shift(2)
      steps.push(2)
      if steps.sum == n
        solution_count += steps.permutation.map { |x| x.hash }.uniq.count
      end
    end
    solution_count
  end
end

test_cases = [
  {
    params: 2,
    result: 2,
  },
  {
    params: 3,
    result: 3,
  },
  {
    params: 8,
    result: 3,
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
)
