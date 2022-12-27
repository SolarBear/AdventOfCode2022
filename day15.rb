file = File.open('input15.txt')

rows = {}
beacons = []

def merge_ranges(r1, r2)
  if r2.nil? || r1.cover?(r2)
    r1
  elsif r1.nil? || r2.cover?(r1)
    r2
  else
    Range.new([r1.min, r2.min].min, [r1.max, r2.max].max)
  end
end

the_row = 2_000_000

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

  if sensor_y - manhattan_distance <= the_row && sensor_y + manhattan_distance >= the_row
    x_dist = manhattan_distance - (the_row - sensor_y).abs
    rows[the_row] = merge_ranges((sensor_x - x_dist..sensor_x + x_dist), rows[the_row])
  end
end

puts rows[the_row].size - beacons.filter { |b| b[:y] == the_row }.length # 5127797

file.close
