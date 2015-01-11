# Thanks to Michael Alexander (BetweenParentheses) -- I had several moments of epiphony about how these work while reading your code.

class Node
  attr_reader :value
  attr_accessor :left, :right
  
  def initialize(value)
    @value = value
  end
  
  def insert(new_val)
    if new_val < @value
      @left ? @left.insert(new_val) : @left = Node.new(new_val)
    elsif new_val > @value
      @right ? @right.insert(new_val) : @right = Node.new(new_val)
    else
      puts "can't insert a non-unique value."
    end
  end
end

# this requires a sorted array as its input. The binary tree generated will be balanced (height minimized).
def make_tree_sorted(arr)
  # deal with (base) cases where we've put in an empty list (the children created from such lists will be nil, ie, there won't be any children.)
  return nil if arr.length == 0
  
  m = arr.length / 2
  this_node = Node.new arr[m]
  # return the node itself if the input array is just one number (because it's the last child of whatever node recursively called it into existence.)
  return this_node if arr.length == 1
  
  this_node.left = make_tree_sorted(arr[0...m])
  this_node.right = make_tree_sorted(arr[m+1..-1])
  # return the root node, from which we can begin searches
  this_node
end

# this returns an unbalanced binary tree.
def make_tree(arr)
  # randomize the order of the input to avoid situations where the height of the tree will be close to its number of elements
  arr.shuffle!               
  root = Node.new arr[-1]
  arr.pop
  arr.each {|num| root.insert(num)}
  root
end

def breadth_first_search(search_val, root)
  queue = []
  queue << root
  until queue.length == 0
    current = queue.shift
    return current if current.value == search_val
    queue << current.left if current.left != nil
    queue << current.right if current.right != nil
  end
  nil
end

def breadth_first_search_firsttry(search_val, root, queue=[], checked=[])
  unless checked.include?(root)
    return root if root.value == search_val
    checked << root
  end
  
  unless (checked.include?(root.left) || root.left == nil)
    return root.left if root.left.value == search_val
    checked << root.left
    queue << root.left
  end
  
  unless (checked.include?(root.right) || root.right == nil)
    return root.right if root.right.value == search_val
    checked << root.right
    queue << root.right
  end
  
  return nil if queue.length == 0
  next_node = queue.shift
  breadth_first_search(search_val, next_node, queue, checked)
end
  
def depth_first_search(search_val, root)
  stack = []
  checked = []
  stack << root
  until stack.length == 0
    current = stack[-1]
    return current if current.value == search_val
    checked << current
    if current.left && !checked.include?(current.left)
      stack << current.left
    elsif current.right && !checked.include?(current.right)
      stack << current.right
    else
      stack.pop
    end
  end
  nil
end 
  
def depth_first_search_firsttry(search_val, root, stack=[], checked=[])
  unless checked.include?(root)
    stack << root
    checked << root
    return root if root.value == search_val
  end
  
  # if the left child hasn't been checked yet, and it isn't nil (it exists); uses DeMorgan's Law: not(A || B) == not(A) && not(B)
  if not ( checked.include?(root.left) || root.left == nil )
    return dfs_rec(search_val, root.left, stack, checked)         
  elsif not ( checked.include?(root.right) || root.right == nil )
    return dfs_rec(search_val, root.right, stack, checked)
  else
    stack.pop
    return nil if stack.length == 0
    return dfs_rec(search_val, stack[-1], stack, checked)
  end
end

def dfs_rec(search_val, root)
  return root if root.value == search_val
  # generate the recursive search for the left child if there's a left child,
  left_search = dfs_rec(search_val, root.left) unless root.left == nil
  # and return it if it exists, **and** doesn't return nil as its result. If we returned a result of nil here, we'd short-circuit the recursive search by stopping after checking just the left-most chain of entries; the nil would be passed up the stack and returned as our result after encountering the very first nil we get as a result of getting to the leftmost leaf (node with no children). We don't want to stop after getting the first nil result; we want to stop only after the very first function call returns nil. So ignore all nil results except for the one that the first function call will return at the end of a fruitless search.
  return left_search unless left_search == nil
  right_search = dfs_rec(search_val, root.right) unless root.right == nil
  return right_search unless right_search == nil
  # ie this one down here
  nil
end

def test(which, search_val, arr=[1,4,8,12,15,33,45,99,102,1000,2222,2345432])
  root_sorted = make_tree_sorted(arr.sort)
  root = make_tree(arr)
  
  sorted_tree_result = "Found from the sorted tree: "
  unsorted_tree_result = "Found from the unsorted tree: "
  
  # enter 1 for which to test breadth_first, 2 to test depth_first, 3 to test dfs_rec
  case which
  when 1
    sorted =  breadth_first_search(search_val, root_sorted)
    unsorted = breadth_first_search(search_val, root)
  when 2
    sorted = depth_first_search(search_val, root_sorted)
    unsorted = depth_first_search(search_val, root)
  when 3
    sorted = dfs_rec(search_val, root_sorted)
    unsorted = dfs_rec(search_val, root)
  end
  
  sorted == nil ? sorted_tree_result += "nil" : sorted_tree_result += sorted.value.to_s
  unsorted == nil ? unsorted_tree_result += "nil" : unsorted_tree_result += unsorted.value.to_s
  
  puts sorted_tree_result
  puts unsorted_tree_result
  return "search complete"
end