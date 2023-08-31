# frozen_string_literal: true

require_relative "common/testrunner"

DEBUG = false

# https://leetcode.com/problems/remove-duplicates-from-sorted-array/
#
# Given an integer array nums sorted in non-decreasing order,
# remove the duplicates in-place such that each unique element
# appears only once. The relative order of the elements should
# be kept the same. Then return the number of unique elements
# in nums.
#
# Consider the number of unique elements of nums to be k, to
# get accepted, you need to do the following things:
#
# Change the array nums such that the first k elements
# of nums contain the unique elements in the order they were
# present in nums initially. The remaining elements of nums
# are not important as well as the size of nums.
#
# Return k.

class Solutions
  def self.first(nums)
    lastval = -999
    k = 0
    0.upto(nums.length - 1) do |i|
      curval = nums[i]
      if lastval == curval
        nums[i] = 999
      else
        k += 1
      end
      lastval = curval
    end
    nums.sort!
    k
  end

  def self.second(nums)
    nums.uniq!
    nums.length
  end
end

test_cases = [
  # {
  #   params: [[1,1,2]],
  #   result: 2,
  # },
  {
    params: [[0, 0, 1, 1, 1, 2, 2, 3, 3, 4]],
    result: 5,
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
)
