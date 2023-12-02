TOTAL_SET = {
  r: 12,
  g: 13,
  b: 14
}.freeze

def parse_set(set_line)
  obj = {
    r: 0,
    g: 0,
    b: 0
  }

  set_line.split(',').each do |x|
    if x.include? 'red'
      obj[:r] = x.to_i
    elsif x.include? 'green'
      obj[:g] = x.to_i
    elsif x.include? 'blue'
      obj[:b] = x.to_i
    end
  end

  obj
end

def fits(set)
  set[:r] <= TOTAL_SET[:r] && set[:g] <= TOTAL_SET[:g] && set[:b] <= TOTAL_SET[:b]
end

def mininum_set(sets)
  sets.reduce do |acc, x|
    { r: [acc[:r], x[:r]].max,
      g: [acc[:g], x[:g]].max,
      b: [acc[:b], x[:b]].max }
  end
end

sets = File.read('input.txt').split("\n").map do |line|
  [line.split(':')[0].sub('Game', '').to_i, line.split(':')[1].split(';').map { |s| parse_set(s) }]
end

# Part 1
fitting_sets = sets.select { |x| x[1].all? { |s| fits(s) } }
puts "Part 1: #{fitting_sets.map { |x| x[0] }.sum}"

# Part 2
power_sets = sets.map { |x| mininum_set(x[1]) }
puts "Part 2: #{power_sets.map { |x| x[:r] * x[:b] * x[:g] }.sum}"
