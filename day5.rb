file = File.open('input5.txt')

stacks1 = nil
stacks2 = nil
read_moves = false

def move_crate_pile(stacks, nb, from, to, unstack)
  crates = stacks[from].shift(nb)
  crates = crates.reverse_each.to_a if unstack
  stacks[to].unshift(*crates)
end

file.readlines.each do |line|
  if stacks1.nil?
    stacks1 = Array.new((line.length + 1) / 4) { [] }
  end

  next if line[1] == '1'

  if line.strip.empty?
    stacks1.map { |stack| stack.filter! { |elem| elem != ' ' } }
    stacks2 = stacks1.map(&:dup)
    read_moves = true
    next
  end

  if read_moves
    nb, from, to = /^move (\d+) from (\d+) to (\d+)$/.match(line.strip).to_a.drop(1).map(&:to_i)
    move_crate_pile(stacks1, nb, from - 1, to - 1, true)
    move_crate_pile(stacks2, nb, from - 1, to - 1, false)
  else
    elems = line.chars.each_slice(4).map.with_index { |e, i| stacks1[i] << e[1] }
  end
end

puts stacks1.map { |stack| stack[0] }.join
puts stacks2.map { |stack| stack[0] }.join
file.close
