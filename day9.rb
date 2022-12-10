require 'set'

class Node
  attr_accessor :next, :value

  def initialize(value)
    @value = value
  end
end

file = File.open('input9.txt')
steps = file.readlines.map(&:strip)
visits = Set[]

rope = Array.new(ARGV[0].to_i) { Node.new({ x: 0, y: 0 }) }
nexx = nil
rope.reverse.each do |knot|
  knot.next = nexx
  nexx = knot
end

def touching?(head, tail)
  (head[:x] - tail[:x]).abs <= 1 && (head[:y] - tail[:y]).abs <= 1
end

def move_tail(head, tail)
  delta_x = head[:x] - tail[:x]
  delta_y = head[:y] - tail[:y]

  if delta_x.abs >= 2
    tail[:x] += delta_x / delta_x.abs

    if delta_y.abs > 0
      tail[:y] += delta_y / delta_y.abs
    end
  else
    tail[:y] += delta_y / delta_y.abs

    if delta_x.abs > 0
      tail[:x] += delta_x / delta_x.abs
    end
  end

  tail
end

steps.each do |step|
  direction, moves = step.split(' ')

  moves.to_i.times do
    case direction
    when 'L'
      rope[0].value[:x] -= 1
    when 'U'
      rope[0].value[:y] += 1
    when 'R'
      rope[0].value[:x] += 1
    when 'D'
      rope[0].value[:y] -= 1
    end

    rope.each do |knot|
      if knot.next.nil?
        visits.add([knot.value[:x], knot.value[:y]])
      else
        head = knot.value
        tail = knot.next.value

        knot.next.value = move_tail(head, tail) unless touching?(head, tail)
      end
    end
  end
end

puts visits.length
file.close
