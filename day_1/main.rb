def interpret(i)
  case i 
    when "one"
        "1"
    when "two"
        "2"
    when "three"
        "3"
    when "four" 
        "4"
    when "five"
        "5"
    when "six"
        "6"
    when "seven"
        "7"
    when "eight"
        "8"           
    when "nine" 
        "9"
    else
        i
  end
end

def extract_digits(input)
  [
    interpret(input.match(/(\d|one|two|three|four|five|six|seven|eight|nine|ten).*$/)[1]), 
    interpret(input.match(/^.*(\d|one|two|three|four|five|six|seven|eight|nine|ten).*$/)[1]), 
  ]
end

puts File.read("input.txt").split("\n").map {|line| extract_digits(line).join("").to_i }.sum
