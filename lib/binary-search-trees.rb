class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return nil if array.empty?
    return Node.new(array.first) if array.size == 1

    middle = (array.size - 1) / 2
    root = Node.new(array[middle])
    root.left = build_tree(array[0...middle])
    root.right = build_tree(array[(middle + 1)..-1])

    root
  end

  def insert(value, node = @root)
    return @root = Node.new(value) if @root.nil?
    return Node.new(value) if node.nil?

    value < node.data ? node.left = insert(value, node.left) : node.right = insert(value, node.right)
    node
  end

  def delete(value, node = @root)
    return node if node.nil?

    current_node = node
    if value < current_node.data
      current_node.left = delete(value, current_node.left)
    elsif value > current_node.data
      current_node.right = delete(value, current_node.right)
    else
      if current_node.left.nil?
        temp = current_node.right
        current_node = nil
        return temp
      elsif current_node.right.nil?
        temp = current_node.left
        current_node = nil
        return temp
      end

      temp = leftmost_node(current_node.right)
      current_node.data = temp.data
      current_node.right = delete(temp.data, current_node.right)
    end
    current_node
  end

  def leftmost_node(node)
    current = node
    current = current.left until current.left.nil?
    current
  end

  def find(value, node = @root)
    return nil if node.nil?
    return node if node.data == value

    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  def level_order(node = @root)
    return if node.nil?

    output = []
    queue = []
    queue.push(node)
    until queue.empty?
      current = queue.shift
      output.push(block_given? ? yield(current) : current.data)
      queue.push(current.left) if current.left
      queue.push(current.right) if current.right
    end
    output
  end

  def inorder(node = @root, output = [], &block)
    return if node.nil?

    inorder(node.left, output, &block)
    output.push(block_given? ? block.call(node) : node.data)
    inorder(node.right, output, &block)

    output
  end

  def preorder(node = @root, output = [], &block)
    return if node.nil?

    output.push(block_given? ? block.call(node) : node.data)
    preorder(node.left, output, &block)
    preorder(node.right, output, &block)

    output
  end

  def postorder(node = @root, output = [], &block)
    return if node.nil?

    postorder(node.left, output, &block)
    postorder(node.right, output, &block)
    output.push(block_given? ? block.call(node) : node.data)

    output
  end

  def height(node = @root, count = -1)
    return count if node.nil?

    count += 1
    [height(node.left, count), height(node.right, count)].max
  end

  def depth(node)
    return nil if node.nil?

    current_node = @root
    count = 0
    until current_node.data == node.data
      count += 1
      current_node = current_node.left if node.data < current_node.data
      current_node = current_node.right if node.data > current_node.data
    end
    count
  end

  def balanced?
    left_height = height(@root.left, 0)
    right_height = height(@root.right, 0)
    (left_height - right_height).abs <= 1
  end

  def rebalance!
    values = inorder
    @root = build_tree(values)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

array = []
until array.size == 15
  array << rand(1..100)
  array.sort!.uniq!
end

tree = Tree.new(array)

print 'balanced? :   '
p tree.balanced?

print "level_order:  "
p tree.level_order

print 'preorder:     '
p tree.preorder

print 'postorder:    '
p tree.postorder

print 'inorder:      '
p tree.inorder
tree.pretty_print

puts "\n"
random = rand(5..16)
puts "Adding #{random} numbers...\n\n"
random.times do
  add = rand(100..500)
  puts "Adding #{add}..."
  tree.insert(add)
end

print 'balanced? :   '
p tree.balanced?
tree.pretty_print

puts '--------------------------------------'
tree.rebalance!
print 'balanced? :   '
p tree.balanced?
tree.pretty_print
