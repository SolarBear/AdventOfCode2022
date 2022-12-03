file = File.open('input3.txt')

total1 = 0
total2 = 0
group = []

def priority(common)
  if common < 'a'
    common.ord - 'A'.ord + 27
  else
    common.ord - 'a'.ord + 1
  end
end

file.readlines.map(&:strip).each do |line|
  group << line.chars

  rest = line.slice!(line.length / 2, line.length)
  common = line.chars.intersection(rest.chars)[0]
  total1 += priority(common)

  next if group.length != 3

  first = group.pop
  total2 += priority(first.intersection(*group)[0])
  group = []
end

file.close
puts total1
puts total2