class TreeNode
  attr_accessor :parent, :left, :right

  def initialize(value, left: nil, right: nil)
    @value = value
    # @parent = parent
    @left = left
    @right = right
  end

  def children
    [@left, @right].compact
  end

  def descendents
    result = children

    # puts "finding children for #{@value}"
    result += left.children if left
    result += right.children if right

    result
  end

  def width; end

  def to_s
    "(#{@value})"
  end
end

# a = TreeNode.new("Aye")
# a.left = TreeNode.new("Bee")
# a.left.left = TreeNode.new("Cee")
# a.right = TreeNode.new("Dee")
# a.right.right = TreeNode.new("Eee")

# puts a.children
