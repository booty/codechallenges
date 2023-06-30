# frozen_string_literal: true

# https://leetcode.com/problems/stone-game-ii/
#
# Alice and Bob continue their games with piles of stones.  There are a number 
# of piles arranged in a row, and each pile has a positive integer number of 
# stones piles[i].  The objective of the game is to end with the most stones. 
# 
# Alice and Bob take turns, with Alice starting first.  Initially, M = 1.
# 
# On each player's turn, that player can take all the stones in the first X 
# remaining piles, where 1 <= X <= 2M.  Then, we set M = max(M, X).
# 
# The game continues until all the stones have been taken.
# 
# Assuming Alice and Bob play optimally, return the maximum number of stones Alice can get.
# 
# Example 1:
#   Input: piles = [2,7,9,4,4] Output: 10 
#   
#   Explanation:  If Alice takes one pile at
#   the beginning, Bob takes two piles, then Alice takes 2 piles again. Alice can
#   get 2 + 4 + 4 = 10 piles in total. If Alice takes two piles at the beginning,
#   then Bob can take all three piles left. In this case, Alice get 2 + 7 = 9
#   piles in total. So we return 10 since it's larger. 
#   
# Example 2:
# 
#   Input: piles = [1,2,3,4,5,100]
#   Output: 104


# Strategy
#
# - For a given state, determine the possible moves
# - Evaluate each possible move
# - Select the optimal one
# -   Q: Is this the local maximum, or the overall maximum?
# -


require "pry-byebug"
require "benchmark/ips"

BM_WARMUP_SECONDS = 0.5
BM_TIME_SECONDS = 2
DEBUG = true

class Move
  attr_accessor :previous_gamestate, :m

  def initialize(previous_gamestate:, x:)
    @previous_gamestate = previous_gamestate
    @x = x
    @m = [x, @previous_gamestate.m].max

    piles = previous_gamestate.piles.dup
    stones_removed = piles.shift(x)

    # binding.pry
    new_scores = previous_gamestate.scores.dup
    new_scores[previous_gamestate.player] += stones_removed.sum

    args = {
      piles:,
      previous_move: self,
      scores: new_scores,
      depth: previous_gamestate.depth + 1,
    }

    if DEBUG
      # debug_info = {
      #   x:,
      #   m:,
      #   previous_piles: previous_gamestate.piles,
      #   stones_removed:,
      #   scores: new_scores,
      # }
      debug_info = "#{previous_gamestate.player} removes #{x} "\
                   "stones (#{stones_removed.join(',')}) "\
                   "for #{stones_removed.sum} pts"
      indent = " " * ((previous_gamestate.depth * 3) + 1)
      puts("#{indent}#{debug_info}, args:#{args.except(:previous_move)}")
    end

    @next_gamestate = GameState.new(**args)
  end

  def to_s
    "pee"
  end
end

class GameState
  attr_accessor :piles, :x, :scores, :depth

  # def scores
  #   if @previous_move
  #     @previous_move.scores
  #   else
  #     { alice: 0, bob: 0 }
  #   end
  # end

  # def depth
  #   result = -1
  #   pointer = previous_gamestate
  #   loop do
  #     result += 1
  #     return result unless pointer || result > 50

  #     pointer = previous_gamestate.previous_gamestate
  #   end
  # end

  def previous_gamestate
    @previous_move&.previous_gamestate
  end

  def previous_player
    previous_gamestate&.player
  end

  def player
    # binding.pry if depth == 1
    @_player ||= case previous_player
                 when nil, :bob
                   :alice
                 else
                   :bob
                 end
  end

  def m
    @previous_move&.m || 1
  end

  def to_s
    "poop"
  end

  def initialize(piles:, previous_move: nil, scores: {alice:0, bob:0}, depth: 0)
    @piles = piles
    @previous_move = previous_move
    @next_moves = []
    @scores = scores
    @depth = depth

    indent = " " * (@depth * 3)
    if piles.empty?
      puts "#{indent}[GameState] game over! #{{ piles:, player:, scores: }}"
    else
      limit = [2 * m, piles.length - 1].min
      1.upto(2 * m).each do |x|
        if DEBUG
          puts "#{indent}[GameState] creating Move #{{ piles:, m:, x:, limit:, player:, }}"
        end
        @next_moves << Move.new(previous_gamestate: self, x:)
      end
    end

    -666
  end
end

class Solutions
  def self.recursive(piles)
    gs = GameState.new(piles:)

  end
end

# ---------------------------------------------------------------------------------

test_cases = [
  { input: [2,7,9,4,4], result: 10 },
  # { input: [1,2,3,4,5,100], result: 104 },
]

def putsif(str)
  puts str if DEBUG
end

class String
  def ellipsize(limit)
    return self if length <= limit

    "#{self[0..limit - 2]}…"
  end
end

def benchmark_label(method_name, test_case)
  "#{method_name}(#{test_case.except(:result).values.join(',').ellipsize(15)})"
end

Benchmark.ips do |bm|
  bm.config(time: BM_TIME_SECONDS, warmup: BM_WARMUP_SECONDS)
  methods = (Solutions.methods - Class.methods)
  methods.each do |meth|
    puts meth
    test_cases.each_with_index do |tcase, _tindex|
      puts "case #{tcase[:input]}"

      work = lambda { Solutions.send(meth, tcase[:input]) }
      actual_result = work.call

      if actual_result == tcase[:result]
        puts " ✅ pass (#{actual_result})"
      else
        puts " ❌ fail!"
        puts "    actual: #{actual_result}"
        puts "    expected: #{tcase[:result]}"
      end

      label = benchmark_label(meth, tcase)
      bm.report(label) { work.call } unless DEBUG
    end
  end
end
