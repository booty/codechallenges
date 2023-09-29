# frozen_string_literal: true

require "benchmark/ips"

test_cases = [
  {
    input: "anviaj",
    result_string: "nviaj",
    result: 5,
  },
  {
    input: "ababcabcd",
    result_string: "abcd",
    result: 4,
  },
  {
    input: "abcabcbb",
    result_string: "abc",
    result: 3,
  },
  {
    input: "bbbbb",
    result_string: "b",
    result: 1,
  },
  {
    input: "pwwkew",
    result_string: "wke",
    result: 3,
  },
  {
    input: "",
    result_string: "",
    result: 0,
  },
  {
    input: "cqrgppmcsfbelddmgdfvscpohfozydydvrlngarbfsfsxkefpkcioswvzkuzqvcnoq",
    result_string: "efpkcioswvz",
    result: 11,
  },
  {
    input: "dvdf",
    result_string: "vdf",
    result: 3,
  },
]

class Solutions
  def self.naive(s)
    return s.length if s.length < 2

    result = 1
    0.upto(s.length) do |start_char|
      (start_char + 1).upto(s.length) do |end_char|
        substring = s[start_char..end_char - 1]

        ary = substring.each_char.to_a

        next unless ary.length == ary.uniq.length

        if substring.length > result
          result = substring.length
          # puts substring
        end
      end
    end
    result
  end

  def self.roving_pointer(s)
    return 0 if s.empty?

    last_char_positions = {}
    streak_start_pos = 0
    current_streak = 0
    longest_streak = 0
    pos = 0

    # 0.upto(s.length - 1) do |pos|
    while pos < s.length
      current_char = s[pos]

      # when is the last time we saw this character?
      # last_seen_pos = last_char_positions[current_char]

      # puts "pos: #{pos} "\
      #      "current_char:#{current_char} "\
      #      "last_seen_pos:#{last_seen_pos} "\
      #      "streak_start_pos:#{streak_start_pos} "\
      #      "current_streak:#{current_streak}"

      # was it last seen inside the current streak?
      if last_char_positions.key?(current_char)
        # well, looks like we're starting a new streak
        current_streak = 0
        pos = streak_start_pos + 1
        streak_start_pos = pos
        last_char_positions = {}
        # puts "  bummer, return to pos #{pos}"
      else
        # cool, streak continues
        # puts "  cool... #{s[streak_start_pos..pos]}"
        pos += 1
        current_streak += 1
        longest_streak = current_streak if current_streak > longest_streak
        last_char_positions[current_char] = pos
      end

    end
    longest_streak
  end

  def self.stolen_slick(s)
    max_length = 0
    start = 0
    last_seen = {}

    s.chars.each_with_index do |c, i|
      start = [start, last_seen[c] + 1].max if last_seen.key?(c)

      last_seen[c] = i
      max_length = [max_length, i - start + 1].max
    end

    max_length
  end
end

(Solutions.methods - Class.methods).each do |meth|
  puts meth
  test_cases.each do |tcase|
    puts "  case #{tcase[:input]} "
    actual_result = Solutions.send(meth, tcase[:input])
    if actual_result == tcase[:result]
      puts "    ✅ pass"
    else
      puts "    ❌ fail!"
      puts "      actual: #{actual_result}"
      puts "      expected: #{tcase[:result]}"
    end
  end
end

Benchmark.ips do |x|
  x.config(time: 1, warmup: 0.5)
  (Solutions.methods - Class.methods).each do |meth|
    x.report(meth) do
      test_cases.each do |tcase|
        tcase[:result] = Solutions.send(meth, tcase[:input])
      end
    end
  end
end
