def compare(left, right)
  if left.is_a?(Integer) && right.is_a?(Integer)
    if left < right
      1
    elsif right < left
      -1
    else
      0
    end
  elsif left.is_a?(Array) && right.is_a?(Array)
    nb = [left.length, right.length].max
    (0...nb).each do |i|
      if i >= left.length
        return 1
      elsif i >= right.length
        return -1
      else
        rez = compare(left[i], right[i])
        return rez if rez != 0
      end
    end

    0
  elsif left.is_a?(Integer)
    left = [left]
    compare(left, right)
  elsif right.is_a?(Integer)
    right = [right]
    compare(left, right)
  else
    raise 'LOLWUT'
  end
end

file = File.open('input13.txt')
text = file.read
file.close

pairs = text.split("\n\n")
ordered = 0

i = 1
pairs.each do |pair|
  left, right = pair.split("\n")
  left = eval(left)
  right = eval(right)

  ordered += i if compare(left, right) == 1

  i += 1
end

puts ordered.to_s # 5580

sorted_pairs = text.split("\n").map { |l| eval(l) }
sorted_pairs << [[2]]
sorted_pairs << [[6]]
sorted_pairs = sorted_pairs.compact.sort { |left, right| -1 * compare(left, right) }.to_a

first = sorted_pairs.find_index([[2]])
second = sorted_pairs.find_index([[6]])

puts ((first + 1) * (second + 1)).to_s # 26200
