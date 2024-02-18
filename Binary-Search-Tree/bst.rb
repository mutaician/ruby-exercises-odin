
class Node
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class BinarySearchTree
  attr_accessor :root
  def initialize
    @root = nil
  end

  def build_tree(array)
    sorted_array = array.sort.uniq
    @root = build_tree_helper(sorted_array)
    @root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value)
    @root = insert_helper(@root, value)
  end

  def delete(value)
    @root = delete_helper(@root, value)
  end

  def find(value)
    find_helper(@root, value)
  end

  def level_order
    result = []
    return result if @root.nil?

    queue = [@root]
    while !queue.empty?
      node = queue.shift
      result << node.value
      queue << node.left if node.left
      queue << node.right if node.right
    end
    result
  end

  def inorder # visits nodes in ascending order (left,root,right)
    result = []
    inorder_helper(@root, result)
    result
  end

  def preorder # current node is visited first, then children (root, left, right)
    result = []
    preorder_helper(@root, result)
    result
  end

  def postorder # children first then current node (left, right, root)
    result = []
    postorder_helper(@root, result)
    result
  end

  def height
    calculate_height(@root)
  end

  def depth(value)
    calculate_depth(@root, value)
  end

  def balanced?
    balanced_helper(@root)
  end

  def rebalance
    array = level_order
    build_tree(array)
  end

  private

  def balanced_helper(node)
    return true if node.nil?

    left_height = calculate_height(node.left)
    right_height = calculate_height(node.right)
    return false if (left_height - right_height).abs > 1
    balanced_helper(node.left) && balanced_helper(node.right)
  end

  def calculate_depth(node, value, current_depth = 0)
    return - 1 if node.nil?
    if value == node.value
      return current_depth
    elsif value < node.value
      return calculate_depth(node.left, value, current_depth + 1)
    else
      return calculate_depth(node.right, value, current_depth + 1)
    end
  end

  def calculate_height(node)
    return -1 if node.nil?
    left_height = calculate_height(node.left)
    right_height = calculate_height(node.right)
    [left_height, right_height].max + 1
  end

  def postorder_helper(node, result)
    return if node.nil?
    postorder_helper(node.left, result)
    postorder_helper(node.right, result)
    result << node.value
  end

  def preorder_helper(node, result)
    return if node.nil?
    result << node.value
    preorder_helper(node.left, result)
    preorder_helper(node.right, result)
  end

  def inorder_helper(node, result)
    return if node.nil?
    inorder_helper(node.left, result)
    result << node.value
    inorder_helper(node.right, result)
  end

  def find_helper(node, value)
    return nil if node.nil?
    if value == node.value
      return node
    elsif value < node.value
      return find_helper(node.left, value)
    else
      return find_helper(node.right, value)
    end
  end

  def delete_helper(node, value)
    return node if node.nil?

    if value < node.value
      node.left = delete_helper(node.left, value)
    elsif value > node.value
      node.right = delete_helper(node.right, value)
    else
      # no chile or only one child
      if node.left.nil?
        return node.right
      elsif node.right.nil?
        return node.left
      end
      # two children
      successor = find_min(node.right)
      node.value = successor.value
      node.right = delete_helper(node.right, successor.value)
    end
    node
  end

  def find_min(node)
    current = node
    while current.left
      current = current.left
    end
    current
  end

  def insert_helper(node, value)
    return Node.new(value) if node.nil?

    if value < node.value
      node.left = insert_helper(node.left, value)
    elsif value > node.value
      node.right = insert_helper(node.right, value)
    end
    node
  end

  def build_tree_helper(array)
    return nil if array.empty?

    mid = array.length / 2
    root = Node.new(array[mid])

    root.left = build_tree_helper(array[0...mid])
    root.right = build_tree_helper(array[(mid + 1)...])
    root
  end

end

bst = BinarySearchTree.new

bst.build_tree(Array.new(15) { rand(1..100)})
p bst.balanced?
bst.insert(103)
bst.insert(105)
bst.insert(110)
bst.insert(143)
bst.insert(104)
puts bst.pretty_print
p bst.balanced?
bst.rebalance
puts bst.pretty_print
p bst.balanced?

p bst.level_order
puts "inorder: #{bst.inorder.inspect}"
puts "preorder: #{bst.preorder.inspect}"
puts "postorder: #{bst.postorder.inspect}"
