class Monkey
  attr_reader :inspections, :items, :test
  attr_accessor :magic

  def initialize(worry_level)
    @worry_level = worry_level
    @items = []
    @operation = nil
    @op_arg = nil
    @test = nil
    @test_true_target = nil
    @test_false_target = nil
    @inspections = 0
    @magic = nil
  end

  def perform_turn(monkeys)
    items = @items.dup
    items.each do |item|
      item = inspect(item)
      item /= @worry_level unless @worry_level == 1

      target = if (item % @test).zero?
                 @test_true_target
               else
                 @test_false_target
               end

      throw_item(monkeys[target], item)
    end

    @items = []
  end

  def inspect(item)
    @inspections += 1
    arg = if @op_arg == 'old'
            item
          else
            @op_arg.to_i
          end

    if @operation == '+'
      item += arg
    elsif @operation == '*'
      item *= arg
    end

    item % @magic
  end

  def throw_item(monkey, item)
    monkey.catch_item(item)
  end

  def catch_item(item)
    @items << item
  end

  def load(lines)
    lines.shift
    _, items = lines.shift.split(':').map(&:strip)
    @items = items.split(',').map(&:to_i)

    _, op = lines.shift.strip.split('old ')
    @operation, @op_arg = op.split(' ')

    @test = lines.shift.split('by ')[1].to_i
    @test_true_target = lines.shift.split('monkey ')[1].strip.to_i
    @test_false_target = lines.shift.split('monkey ')[1].strip.to_i
  end
end

def rounds(nb, monkeys_data, worry_level)
  monkeys = Array.new(monkeys_data.length) { Monkey.new(worry_level) }
  monkeys.each_index { |i| monkeys[i].load(monkeys_data[i].split("\n")) }

  magic = monkeys.reduce(1) { |prev, monkey| prev * monkey.test }
  monkeys.each { |m| m.magic = magic }

  nb.times do
    monkeys.each do |m|
      m.perform_turn(monkeys)
    end
  end

  mb = monkeys.map(&:inspections).max(2)
  mb[0] * mb[1]
end

file = File.open('input11.txt')
monkeys_data = file.read.split("\n\n")

puts rounds(20, monkeys_data, 3) # 78678
puts rounds(10_000, monkeys_data, 1) # 15333249714
