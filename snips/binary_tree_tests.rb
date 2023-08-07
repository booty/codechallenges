# frozen_string_literal: true

require_relative "binary_tree"

module Testable
  class TestResult
    attr_accessor :success, :description, :details

    def initialize(success:, description:, details: [])
      @success = success
      @description = description
      @details = details
    end
  end

  def assert(condition, description)
    record_and_display_result TestResult.new(
      success: condition,
      description:,
    )
  end

  def assert_equal(expected, actual, description = "")
    record_and_display_result TestResult.new(
      success: expected == actual,
      description:,
      details: ["expected: #{expected}", "actual: #{actual}"],
    )
  end

  def test
    tally = { passed: 0, failed: 0 }

    methods_not_to_test = [:assert, :assert_equal, :test_results, :test]
    methods_to_test = public_methods - Object.new.public_methods - methods_not_to_test

    methods_to_test.each do |method|
      puts format_method_name(method)
      send(method)
    end
    puts format_tally
  end

  private

  def format_tally
    passed = 0
    failed = 0
    @test_results.each do |tr|
      if tr.success
        passed += 1
      else
        failed += 1
      end
    end

    "#{format_method_name('RESULTS')}\npassed:#{passed} failed:#{failed}\n\n"
  end

  def record_and_display_result(test_result)
    @test_results ||= []
    @test_results << test_result

    puts format_test_result(test_result)
  end

  def format_method_name(method)
    "\n----[ #{method} ]----"
  end

  def format_test_result(test_result)
    output = []
    if test_result.success
      output << "  👍 #{test_result.description}"
    else
      output << "  🚫 #{test_result.description}"
      output += test_result.details.map { |d| "       #{d}" }
    end
    output.join("\n")
  end
end

class TestTreeNode
  include Testable

  def initialize
    @empty_tree = TreeNode.new("A")

    @simple_tree = TreeNode.from_hash({ A: { left: "B", right: "C" } })
    # @simple_tree.left = TreeNode.new("B")
    # @simple_tree.right = TreeNode.new("C")

    @left_leaning_tree = TreeNode.new("A")
    @left_leaning_tree.left = TreeNode.new("B")
    @left_leaning_tree.left.left = TreeNode.new("C")
    @left_leaning_tree.left.left.left = TreeNode.new("D")

    @family = TreeNode.from_hash(
      {
        Jack: {
          left: {
            John: {
              left: "Euclid",
              right: "Choco",
            },
          },
          right: "Matthew",
        },
      },
    )

    @crooked = TreeNode.from_hash(
      {
        a: {
          right: "b",
          left: {
            c: {
              right: {
                d: {
                  right: {
                    e: {
                      left: {
                        f: {
                          left: {
                            g: {
                              left: "h",
                            },
                          },
                        },
                      },
                    },
                  },
                },
              },
            },
          },
        },
      },
    )
  end

  def test_initialize
    bar = TreeNode.new("bar")
    baz = TreeNode.new("baz")

    foo = TreeNode.new(
      "foo",
      left: bar,
      right: baz,
    )

    assert_equal(foo.value, "foo", "value set correctly")
    assert_equal(foo.left, bar, "left assigned correctly")
    assert_equal(foo.right, baz, "right assigned correctly")
    assert_equal(bar.parent, foo, "left's parent is set")
    assert_equal(baz.parent, foo, "right's parent is set")
  end

  def from_hash
    simple1 = TreeNode.from_hash("foo")
    assert(simple1.is_a?(TreeNode), "creation from stringval")
    assert_equal("foo", simple1.value, "value set from stringval")

    simple2 = TreeNode.from_hash({ foo: nil })
    assert(simple2.is_a?(TreeNode), "creation from simple hash")
    assert_equal("foo", simple2.value, "value set from simple hash")

    assert_equal("Jack", @family.value, "root created from hash")
    assert_equal("John", @family.left.value, "left child")
    assert_equal("Matthew", @family.right.value, "right child")
    assert_equal("Euclid", @family.left.left.value, "left grandchild")
    assert_equal("Choco", @family.left.right.value, "right grandchild")
  end

  def children
    assert_equal(
      [],
      @empty_tree.children,
      "empty tree",
    )
    assert_equal(
      ["John", "Matthew"].sort,
      @family.children.map(&:value).sort,
      "of family",
    )
  end

  def descendents
    assert_equal(
      [],
      @empty_tree.descendents,
      "empty tree",
    )
    assert_equal(
      ["John", "Euclid", "Choco", "Matthew"].sort,
      @family.descendents.map(&:value).sort,
      "of family",
    )
  end

  def width
    assert_equal(0, @empty_tree.width, "width of empty tree")
    assert_equal(2, @simple_tree.width, "width of simple tree")
    assert_equal(3, @family.width, "width of family tree")
    assert_equal(3, @left_leaning_tree.width, "width of left leaning tree")
    assert_equal(3, @crooked.width, "width of crooked tree")
  end
end

TestTreeNode.new.test
