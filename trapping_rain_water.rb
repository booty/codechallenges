# frozen_string_literal: true

require_relative "testrunner"

DEBUG = true

# Given n non-negative integers representing an elevation
# map where the width of each bar is 1, compute how much
# water it can trap after raining.
#
# https://leetcode.com/problems/trapping-rain-water/
#
# Example 1:
#
#    Input: height = [0,1,0,2,1,0,1,3,2,1,2,1]
#    Output: 6
#    Explanation: The above elevation map (black section) is
#                 represented by array [0,1,0,2,1,0,1,3,2,1,2,1].
#                 In this case, 6 units of rain water (blue
#                 section) are # being trapped.
#
# Example 2:
#
#    Input: height = [4,2,0,3,2,5]
#    Output: 9

def array_to_histogram(ary)
  max_y = ary.max
  y_label_width = max_y.to_s.length + 2

  max_y.downto(1) do |cur_y|
    print cur_y.to_s.rjust(max_y.to_s.length + 1)
    print "|"
    0.upto(ary.length - 1) do |cur_x|
      print ary[cur_x] >= cur_y ? " X " : " . "
    end
    print "\n"
  end

  puts "-" * (y_label_width + (ary.length * 3))
  print " " * y_label_width
  0.upto(ary.length - 1) do |cur_x|
    print " "
    print cur_x.to_s.ljust(2)
  end
end

class Solutions
  # this fails because it is O(n^2)
  def self.first_pass(height)
    total_water_count = 0
    1.upto(height.max) do |elevation|
      elevation_water_count = 0
      current_water_count = 0
      hit_rock_yet = false

      0.upto(height.length - 1) do |x|
        in_rock = height[x] >= elevation

        if in_rock
          hit_rock_yet = true
          if current_water_count.positive?
            elevation_water_count += current_water_count
            current_water_count = 0
          end
        elsif hit_rock_yet
          current_water_count += 1
        end
      end

      # putsif("elevation:#{elevation} elevation_water_count:#{elevation_water_count}")
      total_water_count += elevation_water_count
    end

    total_water_count
  end

  # this is... 0(2n) ish?
  def self.second_pass(height)

  end
end

test_cases = [
  {
    params: [[0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]],
    result: 6,
  },
  {
    params: [[4, 2, 0, 3, 2, 5]],
    result: 9,
  },
]

TestRunner.new.run(
  solutions_klass: Solutions,
  test_cases:,
)
