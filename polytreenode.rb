class PolyTreeNode
  def initialize(value)
    @parent = nil
    @children = []
    @value = value
  end

  def parent
    @parent
  end

  def children
    @children
  end

  def value
    @value
  end

  def parent=(new_parent)
    return if @parent == new_parent
    if new_parent.nil?
      @parent.children.delete(self)
      @parent = nil
    elsif @parent.nil?
      @parent = new_parent
      new_parent.children.push(self)
    else
      @parent.children.delete(self)
      @parent = new_parent
      new_parent.children.push(self)
    end
  end

  def add_child(new_child)
    new_child.parent = self
  end

  def remove_child(old_child)
    raise unless old_child && @children.include?(old_child)
    old_child.parent = nil
  end

  def dfs(target_value)
    return self if @value == target_value
    @children.each do |child|
      answer = child.dfs(target_value)
      return answer unless answer.nil?
    end
    nil
  end

  def bfs(target_value)
    queue = [self]
    until queue.empty?
      root = queue.shift
      return root if root.value == target_value
      queue += root.children
    end
    nil
  end
end
