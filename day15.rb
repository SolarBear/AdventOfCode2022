file = File.open('input15.txt')

def trim_range(ranges, min, max)
  ranges.map { |r| Range.new([r.min, min].max, [r.max, max].min) }
end

def ranges_adjacent?(r1, r2)
  r1.end + 1 == r2.begin
end

def ranges_overlap?(r1, r2)
  r1.begin >= r2.begin && r1.begin <= r2.end || r1.end >= r2.begin && r1.end <= r2.end || \
    r2.begin >= r1.begin && r2.begin <= r1.end || r2.end >= r1.begin && r2.end <= r1.end
end

def merge_ranges(r1, r2)
  if r2.instance_of?(Array)
    ranges = []
    new_range = r1

    r2.each do |r|
      if ranges_overlap?(new_range, r)
        new_range = merge_ranges(new_range, r)
      else
        ranges << r
      end
    end

    ranges << new_range
    ranges
  elsif r2.nil? || r1.cover?(r2)
    r1
  elsif r1.nil? || r2.cover?(r1)
    r2
  elsif ranges_overlap?(r1, r2)
    Range.new([r1.min, r2.min].min, [r1.max, r2.max].max)
  else
    [r1, r2]
  end
end

rows = {}
beacons = []
the_row = 2_000_000
min_pos = 0
max_pos = 4_000_000

file.readlines.each do |line|
  sensor, beacon = line.split(':')
  sensor_pos = sensor.split(',')
  sensor_x = sensor_pos[0].split('=')[1].to_i
  sensor_y = sensor_pos[1].split('=')[1].to_i

  beacon_pos = beacon.split(',')
  beacon_x = beacon_pos[0].split('=')[1].to_i
  beacon_y = beacon_pos[1].split('=')[1].to_i

  h_beacon = {x: beacon_x, y: beacon_y}
  beacons << h_beacon unless beacons.include?(h_beacon)

  manhattan_distance = (sensor_x - beacon_x).abs + (sensor_y - beacon_y).abs

  min_y = [sensor_y - manhattan_distance, min_pos].max
  max_y = [sensor_y + manhattan_distance, max_pos].min
  (min_y..max_y).each do |y|
    # TODO limit x values
    x_dist = manhattan_distance - (y - sensor_y).abs
    rows[y] = merge_ranges((sensor_x - x_dist..sensor_x + x_dist), rows[y])

    if rows[y].instance_of?(Array)
      rows[y] = rows[y].sort { |a,b| a.begin <=> b.begin }
    else
      rows[y] = [rows[y]]
    end
  end
end

puts rows[the_row].first.size - beacons.filter { |b| b[:y] == the_row }.length # 5127797

my_rows = rows.keep_if { |k,v| k.between?(min_pos, max_pos)}.transform_values { |v| trim_range(v, min_pos, max_pos) }

my_rows = my_rows.transform_values do |v|
  current = nil
  row = []

  v.size.times do |i|
    current = v[i] if current.nil?

    if i + 1 < v.length
      nxt = v[i + 1]
      if ranges_adjacent?(current, nxt)
        current = (current.begin..nxt.end)
      elsif ranges_adjacent?(nxt, current)
        current = (nxt.begin..current.end)
      else
        row << current
        current = nil
      end
    else # last element
      row << current
    end

    row
  end

  row
end

discontinuities = my_rows.keep_if { |k,v| v != [(min_pos..max_pos)]}
# TODO: do not do this manually from the output!
# y : 2636475
# x : 3129625
# 3129625 * 4000000 + 2636475 = 12518502636475
puts discontinuities.first # 12518502636475

file.close
