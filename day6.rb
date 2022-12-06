file = File.open('input6.txt')
msg = file.read.chars
file.close

PACKET_MARKER = 4
MESSAGE_MARKER = 14

found_marker = false

(0..msg.length).each do |i|
  str = msg.slice(i, MESSAGE_MARKER)
  substr = msg.slice(i, PACKET_MARKER)

  if !found_marker && substr.uniq.length == PACKET_MARKER
    puts i + PACKET_MARKER
    found_marker = true
  end

  if str.uniq.length == MESSAGE_MARKER
    puts i + MESSAGE_MARKER
    break
  end
end
