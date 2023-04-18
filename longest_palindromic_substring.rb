require "benchmark/ips"
require "pry-byebug"

test_cases = [
  { input: "babad", results: ["bab", "aba"] },
  { input: "ccc", results: "ccc" },
  { input: "rgczcpratwyqxaszbuwwcadruayhasynuxnakpmsyhxzlnxmdtsqqlmwnbxvmgvllafrpmlfuqpbhjddmhmbcgmlyeypkfpreddyencsdmgxysctpubvgeedhurvizgqxclhpfrvxggrowaynrtuwvvvwnqlowdihtrdzjffrgoeqivnprdnpvfjuhycpfydjcpfcnkpyujljiesmuxhtizzvwhvpqylvcirwqsmpptyhcqybstsfgjadicwzycswwmpluvzqdvnhkcofptqrzgjqtbvbdxylrylinspncrkxclykccbwridpqckstxdjawvziucrswpsfmisqiozworibeycuarcidbljslwbalcemgymnsxfziattdylrulwrybzztoxhevsdnvvljfzzrgcmagshucoalfiuapgzpqgjjgqsmcvtdsvehewrvtkeqwgmatqdpwlayjcxcavjmgpdyklrjcqvxjqbjucfubgmgpkfdxznkhcejscymuildfnuxwmuklntnyycdcscioimenaeohgpbcpogyifcsatfxeslstkjclauqmywacizyapxlgtcchlxkvygzeucwalhvhbwkvbceqajstxzzppcxoanhyfkgwaelsfdeeviqogjpresnoacegfeejyychabkhszcokdxpaqrprwfdahjqkfptwpeykgumyemgkccynxuvbdpjlrbgqtcqulxodurugofuwzudnhgxdrbbxtrvdnlodyhsifvyspejenpdckevzqrexplpcqtwtxlimfrsjumiygqeemhihcxyngsemcolrnlyhqlbqbcestadoxtrdvcgucntjnfavylip", results: "qgjjgq"},
  { input: "ujtofmboiyyrjzbonysurqfxylvhuzzrzqwcjxibhawifptuammlxstcjmcmfvjuphyyfflkcbwimmpehqrqcdqxglqciduhhuhbjnwaaywofljhwzuqsnhyhahtkilwggineoosnqhdluahhkkbcwbupjcuvzlbzocgmkkyhhglqsvrxsgcglfisbzbawitbjwycareuhyxnbvounqdqdaixgqtljpxpyrccagrkdxsdtvgdjlifknczaacdwxropuxelvmcffiollbuekcfkxzdzuobkrgjedueyospuiuwyppgiwhemyhdjhadcabhgtkotqyneioqzbxviebbvqavtvwgyyrjhnlceyedhfechrbhugotqxkndwxukwtnfiqmstaadlsebfopixrkbvetaoycicsdndmztyqnaehnozchrakt", results: "uhhu"}
]


# does not seem faster than s1 == s1.reverse?
def palindrome?(string, start, finish)
  len = finish-start
  if len.odd?
    0.upto(len / 2).each do |k|
      char1 = string[start+k]
      char2 = string[finish-k]
      return false unless char1==char2
    end
  else
    0.upto(len / 2 - 1).each do |k|
      char1 = string[start+k]
      char2 = string[finish-k]
      return false unless char1==char2
    end
  end
  true
end

def palindromic_substrings(string)
  results = []
  (0..string.length-1).each do |i|
    (i..string.length-1).each do |j|
      results << string[i..j] if palindrome?(string, i, j)
    end
  end
  results
end

class Solutions
  # note: this works, but is (I guess) O(n^2) and does
  # not run quickly enough to be accepted by leetcode
  def self.naive(s)
    palindromic_substrings(s)
      .max { |a,b| a.length <=> b.length }
  end
end


(Solutions.methods - Class.methods).each do |meth|
  puts meth
  test_cases.each_with_index do |tcase, _tindex|
    print "  case #{tcase[:input]}"
    actual_result = Solutions.send(meth, tcase[:input])
    if Array(tcase[:results]).include?(actual_result)
      puts " ✅ pass (#{actual_result})"
    else
      puts " ❌ fail!"
      puts "    actual: #{actual_result}"
      puts "    expected: one of #{tcase[:results]}"
    end
  end
end