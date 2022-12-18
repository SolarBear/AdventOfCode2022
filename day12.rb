file = File.open('input12.txt')

class Node
  attr_accessor :up, :down, :left, :right, :weight, :distance

  def initialize(weight)
    @weight = weight
  end

  def explored?
    !@distance.nil?
  end

  def neighbors
    [@up, @right, @down, @left].filter { |n| !n.nil? && n.weight <= @weight + 1 }
  end

  def to_s
    "#{@weight}: U #{@up&.weight}, R #{@right&.weight}, D #{@down&.weight}, L #{@left&.weight}, dist #{@distance}"
  end
end

def bfs(graph, start, endd)
  levels = [[start]]
  i = 0

  until levels[i].empty?
    levels[i + 1] = []

    levels[i].each do |vertex|
      next unless vertex.distance.nil?

      vertex.distance = i
      vertex.neighbors.each do |neighbor|
        levels[i + 1] << neighbor unless neighbor.explored?
      end
    end

    i += 1
  end

  levels
end

graph = file.readlines.map(&:strip).compact.map do |line|
  line.chars.map do |c|
    weight = case c
             when 'S'
               0
             when 'E'
               27
             else
               c.ord - 'a'.ord + 1
             end
    Node.new(weight)
  end
end

graph.each_index do |row|
  graph[row].each_index do |col|
    node = graph[row][col]
    node.left = graph[row][col - 1] unless col <= 0
    node.right = graph[row][col + 1] unless col + 1 >= graph[0].length
    node.up = graph[row - 1][col] unless row <= 0
    node.down = graph[row + 1][col] unless row + 1 >= graph.length
    node.distance = nil
  end
end

start = graph[20][0]
endd = graph[20][148]

bfs(graph.dup, start, endd)
puts endd.distance.to_s # 490

min_path = nil
all_a = graph.flatten.filter { |n| n.weight == 1 }

i = 1
all_a.each do |a_start|
  graph.flatten.map { |n| n.distance = nil }

  a_endd = graph[20][148]
  bfs(graph, a_start, a_endd)
  min_path = a_endd.distance if !a_endd.distance.nil? && (min_path.nil? || min_path > a_endd.distance)
  i += 1
end
puts min_path.to_s # 488

file.close
