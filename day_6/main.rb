def parse(input)
  input = input.split("\n").map do |line|
    line.split(':')[1].split(' ').map(&:to_i)
  end

  input[0].zip input[1]
end

input =  parse(File.read('input.txt'))

# let h and t be hold time and travel time
# let tt be total time and d be distance

# h + t = tt
races =  input.map do |tt, d|
  {
    input: [tt, d],
    options: (1..tt).filter_map do |h|
      distance = (tt - h) * h

      if distance > d
        {
          hold: h,
          travel: tt - h,
          distance: distance
        }
      end
    end
  }
end

p(races.map { |x| x[:options].length }.inject(:*))
