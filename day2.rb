LOSS = 0
DRAW = 3
WIN = 6

MAP = {
  'A' => :rock,
  'B' => :paper,
  'C' => :scissors,
  'X' => :rock,
  'Y' => :paper,
  'Z' => :scissors
}

WINS_1 = {
  rock: :paper,
  paper: :scissors,
  scissors: :rock
}

WINS_2 = {
  'X' => LOSS,
  'Y' => DRAW,
  'Z' => WIN
}

MOVE_POINTS = {
  rock: 1,
  paper: 2,
  scissors: 3
}

ORDER = %i[scissors paper rock].freeze

def rps_win(move1, move2)
  return DRAW if move1 == move2

  idx = ORDER.index(move1)

  return move2 == ORDER[idx - 1] ? WIN : LOSS
end

def score(move1, move2)
  MOVE_POINTS[move2] + rps_win(move1, move2)
end

file = File.open('input2.txt')
total1 = 0
total2 = 0

file.readlines.each do |line|
  opponent, me = line.split(' ')
  move1 = MAP[opponent]
  move2 = MAP[me]

  total1 += score(move1, move2)

  idx = ORDER.index(move1)
  case me
  when 'X'
    move2 = ORDER[(idx + 1) % ORDER.length]
  when 'Y'
    move2 = move1
  when 'Z'
    move2 = ORDER[idx - 1]
  end

  total2 += score(move1, move2)
end

puts total1 # 12772
puts total2 # 11618
