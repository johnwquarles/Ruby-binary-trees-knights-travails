class Square
  attr_reader :x, :y, :parent_obj, :children
  
  def initialize(x, y, parent_obj = nil)
    @x = x
    @y = y
    @parent_obj = parent_obj
    @children = []
  end
  
  def make_children
    candidates = []
    candidates.push([@x + 2, @y - 1]).push([@x + 2, @y + 1]).push([@x + 1, @y - 2]).push([@x + 1, @y + 2]).push([@x - 1, @y - 2]).push([@x - 1, @y + 2]).push([@x - 2, @y - 1]).push([@x - 2, @y + 1])
    children = candidates.select{|cand| cand[0] >= 0 && cand[0] <= 7 && cand[1] >= 0 && cand[1] <= 7}
    # make objects out of the possible move coordinates.
    children = children.map{|child_coords| Square.new(child_coords[0], child_coords[1], self)}
    @children = children
  end
end

# this function will return the searched square (object) once it finds it, using a breadth-first search. 
# The square objects generated along the way all include their parent square, so by
# going back up through the final square's parents, parent's parents, etc., we will be able to generate the route that we took to get to it.
def get_search_obj(search_obj, root_obj)
  queue = []
  queue << root_obj
  loop do
    current = queue.shift
    return current if current.x == search_obj.x && current.y == search_obj.y
    current.make_children.each {|child| queue << child}
  end
end

# this function takes in two arrays, generates root and search objects, 
# and returns the route taken to the search object, using the idea mentioned previously (going up through the search object's parents).
# sample input: get_route([2,2], [3,3])
def get_route(root_arr, search_arr)
  search_obj = Square.new(search_arr[0], search_arr[1])
  root_obj = Square.new(root_arr[0], root_arr[1])
  result = get_search_obj(search_obj, root_obj)
  
  route = []
  route.unshift([search_obj.x, search_obj.y])
  current = result.parent_obj
  until current == nil
    route.unshift [current.x, current.y]
    current = current.parent_obj
  end
  puts "You made it in #{route.length - 1} moves! Here's your route:"
  route.each {|square| puts square.inspect}
  return nil
end