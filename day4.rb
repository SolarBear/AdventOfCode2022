file = File.open('input4.txt')

overlaps1 = 0
overlaps2 = 0

def elf_range(line)
  min, max = line.split('-')
  (min.to_i..max.to_i).to_a
end

file.readlines.each do |line|
  first, second = line.split(',')
  first = elf_range(first)
  second = elf_range(second)

  overlaps1 += 1 if first.difference(second).empty? || second.difference(first).empty?

  overlaps2 += 1 if first.intersect?(second) || second.intersect?(first)
end

file.close
puts overlaps1
puts overlaps2
