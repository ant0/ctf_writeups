require 'base64'

# join all lines together to process data easier
data = File.read('2_of_clubs_msflag.txt').delete(' ').delete "\n"

output = ""

# iterate based on number of indexes found from manual scanning
(0..467).each do |i|
	# there's actually two matches with "scan", but only need one since they're the same so use "match"
	index_position = data.enum_for(:match, /,Index=\"#{i}\"/).map { Regexp.last_match.begin(0) }.join.to_i
	b64_start = (i == 467) ? index_position - 2 - 4567 : index_position - 2 - 7999
	b64_end = index_position - 2
	output << (b64_start..b64_end).map { |x| data[x] }.join
end

# output gets decoded to a string of ints - convert ints to hex to write to file
decoded = Base64.decode64(output).delete("\x00").split.map(&:to_i).map { |x| x.to_s(16).rjust(2,'0') }.join

File.open("2_of_clubs.png", "wb"){|fh|
  decoded.scan(/.{2}/) { |e| fh.putc(e.hex) }
}
