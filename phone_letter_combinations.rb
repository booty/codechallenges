# frozen_string_literal: true

require "benchmark/ips"
require "pry-byebug"

test_cases = [
  { input: "", output: [] },
  { input: "1", output: [] },
  { input: "12", output: ["a", "b", "c"] },
  { input: "2", output:  ["a", "b", "c"] },
  { input: "23", output: ["ad", "ae", "af", "bd", "be", "bf", "cd", "ce", "cf"] },
  { input: "4321",
    output: ["gda", "gdb", "gdc", "gea", "geb", "gec", "gfa", "gfb", "gfc", "hda", "hdb", "hdc", "hea", "heb", "hec",
             "hfa", "hfb", "hfc", "ida", "idb", "idc", "iea", "ieb", "iec", "ifa", "ifb", "ifc"] },
  { input: "9999",
    output: ["wwww", "wwwx", "wwwy", "wwwz", "wwxw", "wwxx", "wwxy", "wwxz", "wwyw", "wwyx", "wwyy", "wwyz", "wwzw",
             "wwzx", "wwzy", "wwzz", "wxww", "wxwx", "wxwy", "wxwz", "wxxw", "wxxx", "wxxy", "wxxz", "wxyw", "wxyx", "wxyy", "wxyz", "wxzw", "wxzx", "wxzy", "wxzz", "wyww", "wywx", "wywy", "wywz", "wyxw", "wyxx", "wyxy", "wyxz", "wyyw", "wyyx", "wyyy", "wyyz", "wyzw", "wyzx", "wyzy", "wyzz", "wzww", "wzwx", "wzwy", "wzwz", "wzxw", "wzxx", "wzxy", "wzxz", "wzyw", "wzyx", "wzyy", "wzyz", "wzzw", "wzzx", "wzzy", "wzzz", "xwww", "xwwx", "xwwy", "xwwz", "xwxw", "xwxx", "xwxy", "xwxz", "xwyw", "xwyx", "xwyy", "xwyz", "xwzw", "xwzx", "xwzy", "xwzz", "xxww", "xxwx", "xxwy", "xxwz", "xxxw", "xxxx", "xxxy", "xxxz", "xxyw", "xxyx", "xxyy", "xxyz", "xxzw", "xxzx", "xxzy", "xxzz", "xyww", "xywx", "xywy", "xywz", "xyxw", "xyxx", "xyxy", "xyxz", "xyyw", "xyyx", "xyyy", "xyyz", "xyzw", "xyzx", "xyzy", "xyzz", "xzww", "xzwx", "xzwy", "xzwz", "xzxw", "xzxx", "xzxy", "xzxz", "xzyw", "xzyx", "xzyy", "xzyz", "xzzw", "xzzx", "xzzy", "xzzz", "ywww", "ywwx", "ywwy", "ywwz", "ywxw", "ywxx", "ywxy", "ywxz", "ywyw", "ywyx", "ywyy", "ywyz", "ywzw", "ywzx", "ywzy", "ywzz", "yxww", "yxwx", "yxwy", "yxwz", "yxxw", "yxxx", "yxxy", "yxxz", "yxyw", "yxyx", "yxyy", "yxyz", "yxzw", "yxzx", "yxzy", "yxzz", "yyww", "yywx", "yywy", "yywz", "yyxw", "yyxx", "yyxy", "yyxz", "yyyw", "yyyx", "yyyy", "yyyz", "yyzw", "yyzx", "yyzy", "yyzz", "yzww", "yzwx", "yzwy", "yzwz", "yzxw", "yzxx", "yzxy", "yzxz", "yzyw", "yzyx", "yzyy", "yzyz", "yzzw", "yzzx", "yzzy", "yzzz", "zwww", "zwwx", "zwwy", "zwwz", "zwxw", "zwxx", "zwxy", "zwxz", "zwyw", "zwyx", "zwyy", "zwyz", "zwzw", "zwzx", "zwzy", "zwzz", "zxww", "zxwx", "zxwy", "zxwz", "zxxw", "zxxx", "zxxy", "zxxz", "zxyw", "zxyx", "zxyy", "zxyz", "zxzw", "zxzx", "zxzy", "zxzz", "zyww", "zywx", "zywy", "zywz", "zyxw", "zyxx", "zyxy", "zyxz", "zyyw", "zyyx", "zyyy", "zyyz", "zyzw", "zyzx", "zyzy", "zyzz", "zzww", "zzwx", "zzwy", "zzwz", "zzxw", "zzxx", "zzxy", "zzxz", "zzyw", "zzyx", "zzyy", "zzyz", "zzzw", "zzzx", "zzzy", "zzzz"] },
]

class Solutions
  def self.naive(digits)
    return [] if digits == ""

    mappings =
      {
        "1" => "",
        "2" => "abc",
        "3" => "def",
        "4" => "ghi",
        "5" => "jkl",
        "6" => "mno",
        "7" => "pqrs",
        "8" => "tuv",
        "9" => "wxyz",
      }

    results = [""]

    digits[0..-1].each_char do |c|
      next if c == "1"

      current_chars = mappings[c]
      new_results = []
      results.each do |r|
        current_chars.each_char do |cc|
          new_results.push r + cc
        end
        results = new_results if new_results.any?
      end
    end
    results.reject(&:empty?)
  end
end

(Solutions.methods - Class.methods - [:mappings]).each do |meth|
  puts meth
  test_cases.each do |tcase|
    puts "  case #{tcase[:input]}"
    actual_output = Solutions.send(meth, tcase[:input])
    if actual_output == tcase[:output]
      puts " ✅ pass (#{actual_output})"
    else
      puts " ❌ fail!"
      puts "    actual: #{actual_output}"
      puts "    expected: #{tcase[:output]}"
    end
  end
end
