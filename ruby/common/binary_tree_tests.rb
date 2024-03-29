# frozen_string_literal: true

require_relative "binary_tree"
require "tinytest"

class TestTreeNode
  include TinyTest

  def initialize
    @empty_tree = TreeNode.new("A")

    @simple_tree = TreeNode.from_hash({ A: { left: "B", right: "C" } })

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

  def depth
    assert_equal(0, @empty_tree.depth, "depth of empty tree")
    assert_equal(1, @simple_tree.right.depth, "depth of simple tree node")
    assert_equal(3, @left_leaning_tree.left.left.left.depth, "depth of left leaning tree")
  end

  def max_descendent_depth
    assert_equal(0, @empty_tree.max_descendent_depth, "max depth of empty tree")
    assert_equal(1, @simple_tree.max_descendent_depth, "max depth of simple tree")
    assert_equal(3, @left_leaning_tree.max_descendent_depth, "max depth of left leaning tree")
    assert_equal(6, @crooked.max_descendent_depth, "max depth of crooked tree")
  end

  def leaf_nodes
    assert_equal(
      ["A"],
      @empty_tree.leaf_nodes.map(&:value),
      "empty tree",
    )
    assert_equal(
      ["D"],
      @left_leaning_tree.leaf_nodes.map(&:value),
      "left leaning tree",
    )
    assert_equal(
      ["b", "h"],
      @crooked.leaf_nodes.map(&:value).sort,
      "crooked tree",
    )
  end
end

TestTreeNode.new.test
