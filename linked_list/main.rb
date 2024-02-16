
class Node
  attr_accessor :value, :next_node
  def initialize(value=nil, next_node=nil)
    @value = value
    @next_node = next_node
  end
end

class LinkedList
  def initialize
    @head = nil
  end

  def append(value)
    if @head.nil?
      @head = Node.new(value)
    else
      current = @head
      while !current.next_node.nil?
        current = current.next_node
      end
      current.next_node = Node.new(value)
    end
  end

  def prepend(value)
    new_node = Node.new(value)
    new_node.next_node = @head
    @head = new_node
  end

  def size
    count = 0
    current = @head
    while current
      count += 1
      current = current.next_node
    end
    count
  end

  def head
    @head
  end

  def tail
    current = @head
    while current && current.next_node
      current = current.next_node
    end
    current
  end

  def at(index)
    return nil if @head.nil?
    current_index = 0
    current = @head
    while current
      return current if current_index == index
      current_index += 1
      current = current.next_node
    end
    nil
  end

  def pop
    return nil if @head.nil?
    if @head.next_node.nil?
      value = @head.value
      @head = nil
      return value
    end
    current = @head
    while current.next_node.next_node
      current = current.next_node
    end
    value = current.next_node.value
    current.next_node = nil
    value
  end

  def contains?(value)
    current = @head
    while current
      return true if current.value == value
      current = current.next_node
    end
    false
  end

  def find(value)
    index = 0
    current = @head
    while current
      return index if current.value == value
      index += 1
      current = current.next_node
    end
    nil
  end

  def to_s
    elements = []
    current = @head
    while current
      elements << current.value
      current = current.next_node
    end
    elements.join(" -> ")
  end

  def insert_at(index, value)
    if index.zero?
      prepend(value)
    else
      prev_node = at(index - 1)
      return nil if prev_node.nil?
      new_node = Node.new(value)
      new_node.next_node = prev_node.next_node
      prev_node.next_node = new_node
    end
  end

  def delete(value)
    return nil if @head.nil?
    if @head.value == value
      @head = @head.next_node
      return value
    end
    current = @head
    while current.next_node
      if current.next_node.value == value
        deleted_value = current.next_node.value
        current.next_node = current.next_node.next_node
        return deleted_value
      end
      current = current.next_node
    end
  end

  def reverse
    previous = nil
    current = @head
    while current
      next_node = current.next_node
      current.next_node = previous
      previous = current
      current = next_node
    end
    @head = previous
  end

end
