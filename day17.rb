file = File.open('input17.txt')

WIDTH = 7
FALL_HEIGHT = 4
ROCKS = 2022

moves = file.read

patterns = [
  # horizontal bar
  [{y: 0, h: 1}, {y: 0, h: 1}, {y: 0, h: 1}, {y: 0, h: 1}],
  # plus sign
  [{y: 1, h: 1}, {y: 0, h: 3}, {y: 1, h: 1}],
  # inverted L
  [{y: 0, h: 1}, {y: 0, h: 1}, {y: 0, h: 3}],
  # vertical bar
  [{y: 0, h: 4}],
  # square
  [{y: 0, h: 2}, {y: 0, h: 2}]
]

pattern_index = 0
input_index = 0

height_map = Array.new(WIDTH, 0)

ROCKS.times do |i|
  current_height = height_map.max
  rock = patterns[i % patterns.length].map(&:clone)
  rock.each { |r| r[:y] += current_height + 4 }

  hit_bottom = false
  offset = 2

  loop do
    input = moves[input_index]
    input_index = (input_index + 1) % moves.length

    new_rock = rock.clone.map(&:clone)
    new_offset = offset

    case input
    when '>'
      new_offset += 1 if offset < WIDTH - rock.length
    when '<'
      new_offset -= 1 if offset > 0
    end

    hit_wall = rock.map.with_index { |r, j| r[:y] <= height_map[j + new_offset] }.any?
    offset = new_offset unless hit_wall

    rock.each_index do |j|
      if rock[j][:y] - 1 <= height_map[j + offset]
        hit_bottom = true
        break
      end

      new_rock[j][:y] -= 1
    end

    break if hit_bottom

    rock = new_rock
  end
  rock.each_index do |j|
    height_map[j + offset] = rock[j][:y] + rock[j][:h] - 1
  end

  pattern_index = (pattern_index + 1) % patterns.length
end

# < 3080
puts height_map.max

file.close
