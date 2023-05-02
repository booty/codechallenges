# frozen_string_literal: true

# https://leetcode.com/problems/longest-palindromic-substring/

require "benchmark/ips"
require "pry-byebug"

BM_WARMUP_SECONDS = 0.5
BM_TIME_SECONDS = 1.5
DEBUG = true

# rubocop:disable Layout/LineLength
test_cases = [
  # { input: "a", result: ["a"] },
  # { input: "ac", result: ["a", "c"] },
  # { input: "babad", result: ["bab", "aba"] },
  # { input: "ccc", result: ["ccc"] },
  # { input: "johnabbazz", result: ["abba"] },
  # { input: "johnabazyz", result: ["aba"] },
  # { input: "johnabcbazyz", result: ["abcba"] },
  # { input: "johnabbazyz", result: ["abba"] },
  # { input: "bbdzyx", result: ["bb"] },
  # { input: "zyxjj", result: ["jj"] },
  # { input: "zyxojjo", result: ["ojjo"] },
  # { input: "abvba", result: ["abvba"] },
  # { input: "aabbbaa", result: ["aabbbaa"] },
  # { input: "aabbaa", result: ["aabbaa"] },
  {
    input: "aaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhhiiiiiiiiiijjjjjjjjjjkkkkkkkkkkllllllllllmmmmmmmmmmnnnnnnnnnnooooooooooppppppppppqqqqqqqqqqrrrrrrrrrrssssssssssttttttttttuuuuuuuuuuvvvvvvvvvvwwwwwwwwwwxxxxxxxxxxyyyyyyyyyyzzzzzzzzzzyyyyyyyyyyxxxxxxxxxxwwwwwwwwwwvvvvvvvvvvuuuuuuuuuuttttttttttssssssssssrrrrrrrrrrqqqqqqqqqqppppppppppoooooooooonnnnnnnnnnmmmmmmmmmmllllllllllkkkkkkkkkkjjjjjjjjjjiiiiiiiiiihhhhhhhhhhggggggggggffffffffffeeeeeeeeeeddddddddddccccccccccbbbbbbbbbbaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhhiiiiiiiiiijjjjjjjjjjkkkkkkkkkkllllllllllmmmmmmmmmmnnnnnnnnnnooooooooooppppppppppqqqqqqqqqqrrrrrrrrrrssssssssssttttttttttuuuuuuuuuuvvvvvvvvvvwwwwwwwwwwxxxxxxxxxxyyyyyyyyyyzzzzzzzzzzyyyyyyyyyyxxxxxxxxxxwwwwwwwwwwvvvvvvvvvvuuuuuuuuuuttttttttttssssssssssrrrrrrrrrrqqqqqqqqqqppppppppppoooooooooonnnnnnnnnnmmmmmmmmmmllllllllllkkkkkkkkkkjjjjjjjjjjiiiiiiiiiihhhhhhhhhhggggggggggffffffffffeeeeeeeeeeddddddddddccccccccccbbbbbbbbbbaaaa",
    result: ["aaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhhiiiiiiiiiijjjjjjjjjjkkkkkkkkkkllllllllllmmmmmmmmmmnnnnnnnnnnooooooooooppppppppppqqqqqqqqqqrrrrrrrrrrssssssssssttttttttttuuuuuuuuuuvvvvvvvvvvwwwwwwwwwwxxxxxxxxxxyyyyyyyyyyzzzzzzzzzzyyyyyyyyyyxxxxxxxxxxwwwwwwwwwwvvvvvvvvvvuuuuuuuuuuttttttttttssssssssssrrrrrrrrrrqqqqqqqqqqppppppppppoooooooooonnnnnnnnnnmmmmmmmmmmllllllllllkkkkkkkkkkjjjjjjjjjjiiiiiiiiiihhhhhhhhhhggggggggggffffffffffeeeeeeeeeeddddddddddccccccccccbbbbbbbbbbaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhhiiiiiiiiiijjjjjjjjjjkkkkkkkkkkllllllllllmmmmmmmmmmnnnnnnnnnnooooooooooppppppppppqqqqqqqqqqrrrrrrrrrrssssssssssttttttttttuuuuuuuuuuvvvvvvvvvvwwwwwwwwwwxxxxxxxxxxyyyyyyyyyyzzzzzzzzzzyyyyyyyyyyxxxxxxxxxxwwwwwwwwwwvvvvvvvvvvuuuuuuuuuuttttttttttssssssssssrrrrrrrrrrqqqqqqqqqqppppppppppoooooooooonnnnnnnnnnmmmmmmmmmmllllllllllkkkkkkkkkkjjjjjjjjjjiiiiiiiiiihhhhhhhhhhggggggggggffffffffffeeeeeeeeeeddddddddddccccccccccbbbbbbbbbbaaaa"],
  },
  {
    input: "1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
    result: ["1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"]
  }
  # {
  #   input: "rgczcpratwyqxaszbuwwcadruayhasynuxnakpmsyhxzlnxmdtsqqlmwnbxvmgvllafrpmlfuqpbhjddmhmbcgmlyeypkfpreddyencsdmgxysctpubvgeedhurvizgqxclhpfrvxggrowaynrtuwvvvwnqlowdihtrdzjffrgoeqivnprdnpvfjuhycpfydjcpfcnkpyujljiesmuxhtizzvwhvpqylvcirwqsmpptyhcqybstsfgjadicwzycswwmpluvzqdvnhkcofptqrzgjqtbvbdxylrylinspncrkxclykccbwridpqckstxdjawvziucrswpsfmisqiozworibeycuarcidbljslwbalcemgymnsxfziattdylrulwrybzztoxhevsdnvvljfzzrgcmagshucoalfiuapgzpqgjjgqsmcvtdsvehewrvtkeqwgmatqdpwlayjcxcavjmgpdyklrjcqvxjqbjucfubgmgpkfdxznkhcejscymuildfnuxwmuklntnyycdcscioimenaeohgpbcpogyifcsatfxeslstkjclauqmywacizyapxlgtcchlxkvygzeucwalhvhbwkvbceqajstxzzppcxoanhyfkgwaelsfdeeviqogjpresnoacegfeejyychabkhszcokdxpaqrprwfdahjqkfptwpeykgumyemgkccynxuvbdpjlrbgqtcqulxodurugofuwzudnhgxdrbbxtrvdnlodyhsifvyspejenpdckevzqrexplpcqtwtxlimfrsjumiygqeemhihcxyngsemcolrnlyhqlbqbcestadoxtrdvcgucntjnfavylip", result: ["qgjjgq"]
  # },
  # {
  #   input: "ujtofmboiyyrjzbonysurqfxylvhuzzrzqwcjxibhawifptuammlxstcjmcmfvjuphyyfflkcbwimmpehqrqcdqxglqciduhhuhbjnwaaywofljhwzuqsnhyhahtkilwggineoosnqhdluahhkkbcwbupjcuvzlbzocgmkkyhhglqsvrxsgcglfisbzbawitbjwycareuhyxnbvounqdqdaixgqtljpxpyrccagrkdxsdtvgdjlifknczaacdwxropuxelvmcffiollbuekcfkxzdzuobkrgjedueyospuiuwyppgiwhemyhdjhadcabhgtkotqyneioqzbxviebbvqavtvwgyyrjhnlceyedhfechrbhugotqxkndwxukwtnfiqmstaadlsebfopixrkbvetaoycicsdndmztyqnaehnozchrakt", result: ["uhhu"]
  # },
]
# rubocop:enable Layout/LineLength

# does not seem faster than s1 == s1.reverse?
def palindrome?(string, start, finish)
  len = finish - start
  if len.odd?
    0.upto(len / 2).each do |k|
      char1 = string[start + k]
      char2 = string[finish - k]
      return false unless char1 == char2
    end
  else
    0.upto((len / 2) - 1).each do |k|
      char1 = string[start + k]
      char2 = string[finish - k]
      return false unless char1 == char2
    end
  end
  true
end

def palindromic_substrings(string)
  results = []
  (0..string.length - 1).each do |i|
    (i..string.length - 1).each do |j|
      results << string[i..j] if palindrome?(string, i, j)
    end
  end
  results
end

class Solutions
  def self.expand(str)
    return str if str.length == 1

    palindromes = []

    # odd-length palindromes
    1.upto(str.length) do |pos|
      radius = 1

      loop do
        start_pos = pos - radius
        end_pos = pos + radius
        start_char = str[start_pos]
        end_char = str[end_pos]

        putsif("[odd] pos:#{pos} radius:#{radius} start_pos:#{start_pos}(#{start_char}) end_pos:#{end_pos}(#{end_char}) #{str[start_pos..end_pos]}")

        break if start_pos.negative?
        break unless start_char == end_char

        putsif("...odd palindrome! #{str[start_pos..end_pos]}")
        palindromes << str[start_pos..end_pos]
        radius += 1
      end
    end

    # even-length palindromes
    0.upto(str.length) do |pos|
      radius = 1

      loop do
        start_pos = pos - radius + 1
        end_pos = pos + radius
        start_char = str[start_pos]
        end_char = str[end_pos]

        putsif("[even] pos:#{pos} radius:#{radius} start_pos:#{start_pos}(#{start_char}) end_pos:#{end_pos}(#{end_char}) #{str[start_pos..end_pos]}")

        break if start_pos.negative?
        break if end_pos >= str.length
        break unless start_char == end_char

        putsif("...even palindrome! #{str[start_pos..end_pos]}")
        palindromes << str[start_pos..end_pos]
        radius += 1
      end
    end

    return str[0] if palindromes.empty?

    palindromes.max_by(&:length)
  end

  # note: this works, but is (I guess) O(n^2) and does
  # not run quickly enough to be accepted by leetcode
  # correction: it's O(n^3)
  def self.naive(str)
    candidates = palindromic_substrings(str).
      max_by(&:length)
  end
end

def putsif(str)
  return unless DEBUG

  puts str
end

def benchmark_label(method_name, test_case)
  sprintf(
    "%-40s",
    "#{method_name} (#{test_case.except(:result).values.join(', ')[0..20]})",
  )
end

Benchmark.ips do |bm|
  bm.config(time: BM_TIME_SECONDS, warmup: BM_WARMUP_SECONDS)
  methods = (Solutions.methods - Class.methods)
  methods.each do |meth|
    puts meth
    test_cases.each_with_index do |tcase, _tindex|
      print "  case #{tcase[:input]}"

      work = lambda { Solutions.send(meth, tcase[:input]) }
      actual_result = work.call

      if tcase[:result].include?(actual_result)
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
