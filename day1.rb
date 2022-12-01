file = File.open('input1.txt')
sums = [0]

file.readlines.map(&:strip).each do |line|
  if line == ''
    sums.prepend(0)
  else
    sums[0] += line.to_i
  end
end

file.close
puts sums.max
puts sums.max(3).sum
