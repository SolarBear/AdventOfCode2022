class Node
  attr_accessor :name, :parent

  def initialize(parent, name)
    @name = name
    @parent = parent
  end

  def children
    {}
  end
end

class FileNode < Node
  attr_reader :size

  def initialize(parent, name, size)
    super(parent, name)
    @size = size
  end
end

class DirNode < Node
  attr_reader :children

  def initialize(parent, name)
    super
    @children = {}
    @size = nil
  end

  def size
    @size = @children.values.map(&:size).sum if @size.nil?

    @size
  end
end

def parse_ls(lines, cwd)
  lines.each do |line|
    arg, name = line.split(' ')

    if arg == 'dir'
      cwd.children[name] = DirNode.new(cwd, name)
    else
      cwd.children[name] = FileNode.new(cwd, name, arg.to_i)
    end
  end
end

def crawl_size(max_size, root)
  total = 0

  rootsize = root.size
  total += rootsize if rootsize <= max_size

  root.children.each_value do |child|
    next if child.instance_of?(FileNode)

    total += crawl_size(max_size, child)
  end

  total
end

def crawl_largest(required_size, root)
  large_enough = []
  large_enough << root.size if root.size >= required_size
  large_enough << root.children.values.map { |c| crawl_largest(required_size, c) }
end

file = File.open('input7.txt')

root = DirNode.new(nil, '/')
cwd = root

blocks = file.read.split('$').drop(2)
file.close

blocks.each do |block|
  lines = block.strip.split("\n")
  command = lines.shift

  if command.start_with?('cd')
    dir = command.delete_prefix('cd ')

    cwd = if dir == '..'
            cwd.parent
          else
            cwd = cwd.children[dir]
          end
  elsif command.start_with?('ls')
    parse_ls(lines, cwd)
  end
end

puts crawl_size(100_000, root)

required = root.size + 30_000_000 - 70_000_000
puts crawl_largest(required, root).flatten.sort.shift
