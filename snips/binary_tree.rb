# frozen_string_literal: true

require "pry-byebug"

class TreeNode
  attr_accessor :parent, :value
  attr_reader :left, :right

  def initialize(value, left: nil, right: nil, parent: nil)
    @value = value
    @parent = parent
    self.left = left
    self.right = right
  end

  def left=(tree_node)
    return unless tree_node

    @left = tree_node
    tree_node.parent = self
  end

  def right=(tree_node)
    return unless tree_node

    @right = tree_node
    tree_node.parent = self
  end

  def children
    [left, right].compact
  end

  def descendents
    result = children

    result += left.descendents if left
    result += right.descendents if right

    result
  end

  def depth
    return 0 unless parent

    result = 0
    pointer = self

    while pointer.parent
      result += 1
      pointer = pointer.parent
    end

    result
  end

  # not particularly efficient ¯\_(ツ)_/¯
  def max_descendent_depth
    d = descendents
    return 0 if d.none?

    d.map(&:depth).max
  end

  def width
    return 0 if children.none?

    widths = descendents.map(&:width_from_root)

    min = widths.min
    max = widths.max

    return max if min.positive? && max.positive?
    return min.abs if min.negative? && max.negative?

    (max + min.abs).abs
  end

  def leaf_nodes
    desc = descendents
    return [self] if d.none?

    desc.select { |d| d.children.none? }
  end

  def width_from_root
    return 0 unless parent

    width = 0
    pointer = self

    while pointer.parent
      if pointer.parent.left == pointer
        width -= 1
      else
        width += 1
      end
      pointer = pointer.parent
    end

    width
  end

  def to_s
    "(#{value})"
  end

  def self.from_hash(hsh, parent: nil)
    return TreeNode.new(hsh, parent:) if hsh.is_a?(String)

    new_node = TreeNode.new(hsh.first[0].to_s, parent:)

    return new_node unless hsh.first[1]

    if (left_hash = hsh.first[1][:left])
      new_node.left = TreeNode.from_hash(left_hash, parent: new_node)
    end
    if (right_hash = hsh.first[1][:right])
      new_node.right = TreeNode.from_hash(right_hash, parent: new_node)
    end

    new_node
  end
end
