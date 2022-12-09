file = File.open('input8.txt')

lines = file.readlines.map(&:strip).map(&:chars).map { |l| l.map(&:to_i) }
columns = lines.transpose
file.close

visible = 0
best_scenic = 0

(0...columns.length).each do |x|
  (0...lines.length).each do |y|
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

    if x.zero? || x == columns.length - 1 || y.zero? || y == lines.length - 1 || max_before_x < number || \
       max_after_x < number || max_before_y < number || max_after_y < number
      visible += 1
    end

    score = scenic_before_x * scenic_after_x * scenic_before_y * scenic_after_y
    best_scenic = score if score > best_scenic
  end
end

puts visible
# 1849

puts best_scenic
# 201600