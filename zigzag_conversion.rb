# frozen_string_literal: true

require "pry-byebug"
require "benchmark/ips"

# The string "PAYPALISHIRING" is written in a zigzag pattern
# on a given number of rows like this:
#
#    P   A   H   N
#    A P L S I I G
#    Y   I   R
#
# And then read line by line: "PAHNAPLSIIGYIR"
#
# Write the code that will take a string and make this conversion given a number of rows:
#
# string convert(string s, int numRows);
#
# Input: s = "PAYPALISHIRING", numRows = 4
# Output: "PINALSIGYAHRPI"
# Explanation:
#    P     I    N
#    A   L S  I G
#    Y A   H R
#    P     I

test_cases = [
  { input: "PAYPALISHIRING", rows: 3, result: "PAHNAPLSIIGYIR" },
  { input: "PAYPALISHIRING", rows: 4, result: "PINALSIGYAHRPI" },
  { input: "A", rows: 1, result: "A" },
  { input: "A", rows: 2, result: "A" },
  { input: "ABC", rows: 1, result: "ABC" }

]

def zigzag(s, num_rows)
  return [s] if s.length <= num_rows
  return [s] if s.length == 1
  return [s] if num_rows == 1

  rowlen = s.length - (s.length / num_rows) - num_rows + 1
  rows = Array.new(num_rows) { " " * rowlen }

  current_row = 0
  current_col = 0
  down = true

  s.each_char do |c|
    rows[current_row][current_col] = c
    if down
      current_row += 1
    else
      current_row -= 1
      current_col += 1
    end

    if current_row.negative?
      current_row = 1
      current_col -= 1
      down = true
    elsif current_row >= num_rows
      current_col += 1
      current_row -= 2
      down = false
    end
  end

  rows
end

def zigzag2(s, num_rows)
  return [s] if s.length <= num_rows
  return [s] if s.length == 1
  return [s] if num_rows == 1

  rows = Array.new(num_rows) { String.new }
  current_row = 0
  down = true

  s.each_char do |c|
    rows[current_row] = rows[current_row] + c
    if down
      current_row += 1
    else
      current_row -= 1
    end

    if current_row.negative?
      current_row = 1
      down = true
    elsif current_row >= num_rows
      current_row -= 2
      down = false
    end
  end

  rows
end

class Solutions
  # just barely executes in time
  def self.naive(s, num_rows)
    rows = zigzag(s, num_rows)

    rows.join.gsub(/\s/, "")
  end

  # faster
  def self.naive2(s, num_rows)
    zigzag2(s, num_rows).join
  end
end

(Solutions.methods - Class.methods).each do |meth|
  puts meth
  test_cases.each_with_index do |tcase, _tindex|
    print "  case #{tcase[:input]}"
    actual_result = Solutions.send(meth, tcase[:input], tcase[:rows])
    if actual_result == tcase[:result]
      puts " ✅ pass (#{actual_result})"
    else
      puts " ❌ fail!"
      puts "    actual: #{actual_result}"
      puts "    expected: #{tcase[:result]}"
    end
  end
end
