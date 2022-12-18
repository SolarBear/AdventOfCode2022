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
pairs = file.read.split("\n\n")
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

file.close
