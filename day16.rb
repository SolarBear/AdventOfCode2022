require 'set'

file = File.open('input16.txt')

STARTING_VALVE = 'AA'
STARTING_TIME = 30
STARTING_ELEPHANT_TIME = 26

class Valve
  attr_accessor :name, :flow_rate, :tunnels, :dists

  def initialize(name, flow_rate, tunnels)
    @name = name
    @flow_rate = flow_rate
    @tunnels = tunnels
    @dists = {}
  end

  def to_s
    puts "#{@name}: #{@flow_rate}"
    return if @dists.empty?

    puts 'DISTANCES'
    @dists.each_pair { |k, v| puts "#{k}: #{v}" }
  end
end

# '?' used because of plurals and conjuations
valve_regex = /^Valve (\w{2}) has flow rate=(\d+); tunnels? leads? to valves? (.+)$/

valves = {}

file.readlines.each do |line|
  m = line.match(valve_regex)
  name = m[1]
  flow_rate = m[2].to_i
  neighbors = m[3].split(', ')
  valves[name] = Valve.new(name, flow_rate, neighbors)
end

# Establish a distance hash between a valve and any other valve. Ignore any valve with flow = 0,
# except the starting one.
valves.each_value do |valve|
  next if valve.flow_rate <= 0 && valve.name != STARTING_VALVE

  # Now, ignore any valve with a flow rate of 0 that is not the starting point 'AA'
  visited = Set.new
  to_visit = [[valve.name, 0]]

  loop do
    break if to_visit.empty?

    name, dist = to_visit.shift
    next if visited.member?(name) || dist.nil? || name.nil? # || name != valve.name=

    visited.add(name)

    valve.dists[name] = dist
    to_add = valves[name].tunnels.map { |t| [valves[t].name, dist + 1] }
    to_visit.concat(to_add)
  end
end

valves.filter! { |_, v| v.flow_rate.positive? || v.name == STARTING_VALVE }

def search(graph, current, time)
  valve = graph[current]
  return 0 if valve.nil? || time < 1

  total_flow = valve.flow_rate * time
  graph = graph.filter { |k, _| k != current && (!valve.dists[k].nil? && valve.dists[k] < time) }

  return total_flow if graph.empty?

  cleaned = graph.reject { |k, _| k == valve.name }
  flows = graph.transform_values { |v| search(cleaned, v.name, time - valve.dists[v.name] - 1) }.values
  total_flow + flows.max
end

puts search(valves, STARTING_VALVE, STARTING_TIME)

file.close
