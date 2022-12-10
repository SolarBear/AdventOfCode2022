class CPU
  @@interesting = [20, 60, 100, 140, 180, 220]
  @@crt_width = 40
  @@crt_height = 6

  attr_accessor :signal, :crt

  def initialize
    @cycles = 0
    @register = 1
    @signal = 0
    @crt = Array.new(@@crt_height) { '.' * @@crt_width }
  end

  def run(line)
    instr, arg = line.split(' ')

    case instr
    when 'noop'
      add_cycle(1)
    when 'addx'
      add_cycle(2)
      @register += arg.to_i
    end
  end

  def add_cycle(nb)
    nb.times do
      @cycles += 1
      draw_sprite

      if @@interesting.include?(@cycles)
        @signal += @cycles * @register
      end
    end
  end

  def draw_sprite
    pos = (@cycles - 1) % (@@crt_height * @@crt_width)
    x = pos % @@crt_width
    y = pos / @@crt_width

    @crt[y][x] = '#' if @register >= pos % @@crt_width - 1 && @register <= pos % @@crt_width + 1
  end
end

cpu = CPU.new

file = File.open('input10.txt')
file.readlines.map(&:strip).each do |line|
  cpu.run(line)
end

puts cpu.signal # 12540
puts cpu.crt # FECZELHE
file.close
