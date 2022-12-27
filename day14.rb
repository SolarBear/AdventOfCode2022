file = File.open('input14.txt')

def create_map(lines, min_x, max_x, min_y, max_y)
  map = Array.new(max_y - min_y + 1) { Array.new(max_x - min_x + 1) { '.' } }

  lines.each do |line|
    line.each_index do |j|
      break if line[j + 1].nil?

      low_y, high_y = [line[j][:y], line[j + 1][:y]].minmax
      (low_y..high_y).each do |y|
        low_x, high_x = [line[j][:x], line[j + 1][:x]].minmax

        (low_x..high_x).each do |x|
          map[y][x] = '#'
        end
      end
    end
  end

  map
end

def sand_fall(map, sand)
  x = sand[:x]
  y = sand[:y]

  if y + 1 >= map.length || x < 0 || x >= map[0].length
    nil
  elsif map[y + 1][x] == '.'
    sand_fall(map, { x: x, y: y + 1 })
  elsif map[y + 1][x - 1] == '.'
    sand_fall(map, { x: x - 1, y: y + 1 })
  elsif map[y + 1][x + 1] == '.'
    sand_fall(map, { x: x + 1, y: y + 1 })
  else
    { x: x, y: y }
  end
end

def simul_sand(map, start)
  units = 0
  fell_off = false

  until fell_off
    sand = start.dup
    pos = sand_fall(map, sand)

    if pos == start
      return units + 1
    elsif pos.nil?
      fell_off = true
    else
      units += 1
      map[pos[:y]][pos[:x]] = 'O'
    end
  end

  units
end

lines = file.readlines.map do |line|
  line.split(' -> ').map do |c|
    x, y = c.split(',')
    { x: x.to_i, y: y.to_i }
  end
end

start = { x: 500, y: 0 }
# Gotta do this since it's an array of array of hashes!
lines1 = lines.map { |l| l.map(&:dup) }
all_coords = lines1.flatten << start
min_x, max_x = all_coords.map { |c| c[:x] }.minmax
min_y, max_y = all_coords.map { |c| c[:y] }.minmax
all_coords.each { |c| c[:x] -= min_x; c[:y] -= min_y }

map = create_map(lines1, min_x, max_x, min_y, max_y)

puts simul_sand(map, start) # 793

# Reset the whole thing
start = { x: 500, y: 0 }

map = create_map(lines, 0, start[:x] * 2 + 1, min_y, max_y)
map << Array.new(start[:x] * 2 + 1) { '.' }
map << Array.new(start[:x] * 2 + 1) { '#' }

puts simul_sand(map, start) # 24166

file.close
