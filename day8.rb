file = File.open('input8.txt')

lines = file.readlines.map(&:strip).map(&:chars).map { |l| l.map(&:to_i) }
columns = lines.transpose
file.close

visible = 0
best_scenic = 0
boundaries = [0, lines.length - 1]
coords = (0...columns.length).to_a

coords.product(coords).each do |x, y|
  number = lines[y][x]

  before_x = lines[y].slice(0, x)
  max_before_x = before_x.max
  scenic_before_x = x - before_x.rindex { |i| i >= number }.to_i
  after_x = lines[y].slice(x + 1, lines.length - x - 1)
  max_after_x = after_x.max
  scenic_after_x = after_x.index { |i| i >= number }
  if scenic_after_x.nil?
    scenic_after_x = lines.length - x - 1
  else
    scenic_after_x += 1
  end

  before_y = columns[x].slice(0, y)
  max_before_y = before_y.max
  scenic_before_y = y - before_y.rindex { |i| i >= number }.to_i

  after_y = columns[x].slice(y + 1, columns.length - y - 1)
  max_after_y = after_y.max
  scenic_after_y = after_y.index { |i| i >= number }
  if scenic_after_y.nil?
    scenic_after_y = columns.length - y - 1
  else
    scenic_after_y += 1
  end

  if boundaries.include?(x) || boundaries.include?(y) \
      || [max_before_x, max_after_x, max_before_y, max_after_y].any? { |i| i < number }
    visible += 1
  end

  best_scenic = [best_scenic, scenic_before_x * scenic_after_x * scenic_before_y * scenic_after_y].max
end

puts visible # 1849
puts best_scenic # 201600
